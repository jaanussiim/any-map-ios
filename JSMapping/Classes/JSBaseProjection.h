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

#import "JSProjection.h"

@interface JSBaseProjection : NSObject {
@private
  void *sourceProjection_;
  void *destinationProjection_;
  BOOL sourceIsLatLon_;
  BOOL destIsLatLon_;
  int tileSize_;
}

@property (nonatomic, readonly) int tileSize;

- (id)initWithTileSize:(int)tileSize projectionString:(NSString *)params;
- (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D)point;
- (CLLocationCoordinate2D)inverseTransform:(CLLocationCoordinate2D)point;

@end