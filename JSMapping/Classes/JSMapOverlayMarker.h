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


@interface JSMapOverlayMarker : NSObject {
 @private
  UIImage *markerImage_;
  CGPoint anchorPoint_;
  CGSize markerSize_;
}

@property (nonatomic, readonly) CGPoint anchorPoint;
@property (nonatomic, readonly) CGSize markerSize;
@property (nonatomic, readonly) UIImage *markerImage;

- (id)initWithImage:(UIImage *)image anchorPoint:(CGPoint)anchorPoint;

@end
