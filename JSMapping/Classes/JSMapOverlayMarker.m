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

#import "JSMapOverlayMarker.h"


@implementation JSMapOverlayMarker

@synthesize anchorPoint = anchorPoint_;
@synthesize markerSize = markerSize_;
@synthesize markerImage = markerImage_;

- (id)initWithImage:(UIImage *)image anchorPoint:(CGPoint)anchorPoint {
  self = [super init];

  if (self != nil) {
    markerImage_ = [image retain];
    anchorPoint_ = anchorPoint;
    markerSize_ = markerImage_.size;
  }

  return self;
}

- (void)dealloc {
  [markerImage_ release];

  [super dealloc];
}

@end
