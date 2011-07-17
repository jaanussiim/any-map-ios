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

#import "JSMapPos.h"

@implementation JSMapPos

@synthesize x = x_;
@synthesize y = y_;
@synthesize zoom = zoom_;

- (id)initWithMapX:(int)mapX mapY:(int)mapY zoomLevel:(int)zoomLevel {
  self = [super init];
  
  if (self) {
    [self setX:mapX];
    [self setY:mapY];
    [self setZoom:zoomLevel];
  }
  
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"MapPos: x=%d y=%d z=%d", x_, y_, zoom_];
}

@end
