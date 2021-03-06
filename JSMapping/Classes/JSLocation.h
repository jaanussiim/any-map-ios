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

#import <Foundation/Foundation.h>

@class JSWgsPoint;
@class JSMapPos;

@interface JSLocation : NSObject {
 @private
  JSWgsPoint *wgsPoint_;
  JSMapPos *mapPos_;
  double accuracy_;
}

@property (nonatomic, retain) JSWgsPoint *wgsPoint;
@property (nonatomic, retain) JSMapPos *mapPos;
@property (nonatomic, assign) double accuracy;

- (double)distanceToLocation:(JSLocation *)location;

+ (JSLocation *)locationWithCoreLocation:(CLLocation *)location;

@end
