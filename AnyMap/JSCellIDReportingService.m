/*
 * Copyright 2011 JaanusSiim
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "JSGPSConsumer.h"
#import "JSService.h"
#import "JSCellIDReportingService.h"
#import "JSMapOverlay.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "CellIDRequest.h"
#import "JSLocation.h"
#import "SBJson.h"
#import "Secrets.h"
#import "ASIFormDataRequest.h"
#import "JSWgsPoint.h"

@interface JSCellIDReportingService (Private)

- (void)handleCellIDResponse:(NSString *)response withLocation:(JSLocation *)location;

@end

@implementation JSCellIDReportingService

@synthesize overlay = overlay_;
@synthesize lastPushed = lastPushed_;


- (id)initWithAddress:(NSString *)string {
  self = [super init];

  if (self != nil) {
    serverAddress_ = [[NSString alloc] initWithFormat:@"%@/cellid/reporter", string];
    requestsQueue_ = [[NSOperationQueue alloc] init];
    [requestsQueue_ setMaxConcurrentOperationCount:2];
  }

  return self;
}

- (void)dealloc {
  [serverAddress_ release];
  [overlay_ release];
  [requestsQueue_ release];
  [lastPushed_ release];
  [super dealloc];
}

- (void)didUpdateToLocation:(JSLocation *)location {
  JSLog(@"didUpdateToLocation:%@", location);

  if (location.accuracy > 10) {
    JSLog(@"accuracy:%f", location.accuracy);
    return;
  }

  if (lastPushed_ != nil && [lastPushed_ distanceToLocation:location] < 300) {
    JSLog(@"distance:%f", [lastPushed_ distanceToLocation:location]);
    return;
  }

  [self setLastPushed:location];

  CellIDRequest *cellIDRequest = [[CellIDRequest alloc] initWithURL:[NSURL URLWithString:serverAddress_]];

  [cellIDRequest setCompletionBlock:^{
    NSString *responseString = [cellIDRequest responseString];
    [self handleCellIDResponse:responseString withLocation:location];
  }];

  [cellIDRequest setFailedBlock:^{
    NSError *error = [cellIDRequest error];
  }];

  [cellIDRequest setTimeOutSeconds:5];

  [requestsQueue_ addOperation:cellIDRequest];
  [cellIDRequest release];
}

- (void)handleCellIDResponse:(NSString *)response withLocation:(JSLocation *)location {
  JSLog(@"handleCellIDResponse:%@", response);
  NSDictionary *dictionary = [response JSONValue];
  NSString *status = [dictionary objectForKey:@"status"];
  if (![@"valid" isEqualToString:status]) {
    return;
  }

  ASIFormDataRequest *postMeasure = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/cells/add_measure", kCellidServer]]];
  [postMeasure addPostValue:[dictionary objectForKey:@"lac"] forKey:@"lac"];
  [postMeasure addPostValue:[dictionary objectForKey:@"mcc"] forKey:@"mcc"];
  [postMeasure addPostValue:[dictionary objectForKey:@"mnc"] forKey:@"mnc"];
  [postMeasure addPostValue:[dictionary objectForKey:@"cellId"] forKey:@"cellid"];
  [postMeasure addPostValue:[NSString stringWithFormat:@"%f", location.wgsPoint.lat] forKey:@"lat"];
  [postMeasure addPostValue:[NSString stringWithFormat:@"%f", location.wgsPoint.lon] forKey:@"lon"];

  [postMeasure setCompletionBlock:^{
    NSString *responseString = [postMeasure responseString];
    JSLog(@"post measure reponse: %@", responseString);
    NSDictionary *response = [responseString JSONValue];
    if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
      [overlay_ addLocation:location];
    }
  }];

  [postMeasure setFailedBlock:^{
    NSError *error = [postMeasure error];
    JSLog(@"post measure failure: %@", error);
  }];
  [requestsQueue_ addOperation:postMeasure];
  [postMeasure release];
}

@end
