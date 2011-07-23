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

#import "JSWgsPoint.h"

@implementation JSWgsPoint

@synthesize lon = lon_;
@synthesize lat = lat_;
@synthesize payload = payload_;

- (id)initWithLon:(double)lon lat:(double)lat {
  self = [super init];
  
  if (self) {
    lon_ = lon;
    lat_ = lat;
  }
  
  return self;
}

- (void)dealloc {
  [payload_ release];
  
  [super dealloc];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"lon %f, lat %f", lon_, lat_];
}

+ (JSWgsPoint *)wgsWithLon:(double)lon lat:(double)lat {
  return [[[JSWgsPoint alloc] initWithLon:lon lat:lat] autorelease];
}

+ (JSWgsPoint *)wgsPointWithCoordinate:(CLLocationCoordinate2D)coordinate {
  return [[[JSWgsPoint alloc] initWithLon:coordinate.longitude lat:coordinate.latitude] autorelease];
}

- (double)distanceToPoint:(JSWgsPoint *)point {
  CLLocation *one = [[[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon] autorelease];
  CLLocation *two = [[[CLLocation alloc] initWithLatitude:point.lat longitude:point.lon] autorelease];
  return [one distanceFromLocation:two];
}
@end
