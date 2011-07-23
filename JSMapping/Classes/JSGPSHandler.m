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

#import "JSGPSHandler.h"
#import "JSGPSConsumer.h"
#import "Constants.h"
#import "JSLocation.h"

@interface JSGPSHandler (Private)

- (void)checkManagerState;

@end

@implementation JSGPSHandler

@synthesize listeners = listeners_;
@synthesize locationManager = locationManager_;

- (id)init {
  self = [super init];

  if (self != nil) {
    [self setListeners:[NSArray array]];
  }

  return self;
}

- (void)addGPSConsumer:(id <JSGPSConsumer>)listener {
  NSMutableArray *nextListeners = [[NSMutableArray alloc] initWithArray:listeners_];
  [nextListeners addObject:listener];
  [self setListeners:[NSArray arrayWithArray:nextListeners]];
  [nextListeners release];
  [self checkManagerState];
}

- (void)removeGPSConsumer:(id <JSGPSConsumer>)listener {
  NSMutableArray *nextListeners = [[NSMutableArray alloc] initWithArray:listeners_];
  [nextListeners removeObject:listener];
  [self setListeners:[NSArray arrayWithArray:nextListeners]];
  [nextListeners release];
  [self checkManagerState];
}

- (void)dealloc {
  [listeners_ release];
  [locationManager_ release];
  [super dealloc];
}

- (void)checkManagerState {
  JSLog(@"checkManagerState with %d listeners", [listeners_ count]);
  if (locationManager_ == nil && [listeners_ count] > 0) {
    JSLog(@"create location manager");
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    [manager setDelegate:self];
    [manager setDesiredAccuracy:kCLLocationAccuracyBest];
    [manager startUpdatingLocation];
    [self setLocationManager:manager];
    [manager release];;
  } else if ([listeners_ count] == 0) {
    JSLog(@"remove location manager");
    [locationManager_ stopUpdatingLocation];
    [self setLocationManager:nil];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  JSLocation *location = [JSLocation locationWithCoreLocation:newLocation];
  NSArray *listeners = listeners_;
  for (id<JSGPSConsumer> consumer in listeners) {
    [consumer didUpdateToLocation:location];
  }
}

@end
