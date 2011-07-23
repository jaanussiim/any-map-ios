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

#import "JSLocation.h"
#import "JSWgsPoint.h"
#import "JSMapPos.h"

@implementation JSLocation

@synthesize wgsPoint = wgsPoint_;
@synthesize mapPos = mapPos_;
@synthesize accuracy = accuracy_;


- (void)dealloc {
  [wgsPoint_ release];
  [mapPos_ release];

  [super dealloc];
}

- (double)distanceToLocation:(JSLocation *)location {
  return [self.wgsPoint distanceToPoint:location.wgsPoint];
}

+ (JSLocation *)locationWithCoreLocation:(CLLocation *)location {
  JSLocation *result = [[[JSLocation alloc] init] autorelease];
  [result setWgsPoint:[JSWgsPoint wgsPointWithCoordinate:location.coordinate]];
  [result setAccuracy:location.horizontalAccuracy];
  return result;
}

@end
