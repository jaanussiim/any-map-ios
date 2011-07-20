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

#import "JSMapTilesView.h"
#import "JSBaseMap.h"
#import "JSMapTilesRenderer.h"
#import "Constants.h"

@interface JSMapTilesView (Private)

- (void)initializeView;

@end

@implementation JSMapTilesView

@synthesize displayedMap = displayedMap_;
@synthesize tilesRenderView = tilesRenderView_;


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self != nil) {
    [self initializeView];
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    [self initializeView];
  }

  return self;
}

- (void)dealloc {
  [displayedMap_ release];
  [tilesRenderView_ release];
  [super dealloc];
}

- (void)initializeView {
  [self setDelegate:self];
  [self setShowsHorizontalScrollIndicator:FALSE];
  [self setShowsVerticalScrollIndicator:FALSE];
  [self setBouncesZoom:TRUE];
  [self setDecelerationRate:UIScrollViewDecelerationRateFast];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // center the image as it becomes smaller than the size of the screen

  CGSize boundsSize = self.bounds.size;
  CGRect frameToCenter = tilesRenderView_.frame;

  // center horizontally
  if (frameToCenter.size.width < boundsSize.width) {
    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
  } else {
    frameToCenter.origin.x = 0;
  }

  // center vertically
  if (frameToCenter.size.height < boundsSize.height) {
    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
  } else {
    frameToCenter.origin.y = 0;
  }

  tilesRenderView_.frame = frameToCenter;

  if ([tilesRenderView_ isKindOfClass:[JSMapTilesRenderer class]]) {
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    tilesRenderView_.contentScaleFactor = 1.0;
  }
}

- (void)setDisplayedMap:(JSBaseMap *)map {
  [displayedMap_ autorelease];
  displayedMap_ = [map retain];

  JSMapTilesRenderer *renderer = [[JSMapTilesRenderer alloc] initWithMap:displayedMap_];
  [self addSubview:renderer];
  [self setTilesRenderView:renderer];
  [renderer release];
  [self setContentSize:renderer.frame.size];

  CGSize size = [map contentSize];
  JSLog(@"map size: %@", NSStringFromCGSize(size));
  CGFloat ratio = self.frame.size.height / size.height;
  [self setMaximumZoomScale:1];
  [self setMinimumZoomScale:ratio];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return tilesRenderView_;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  JSLog(@"scrollViewDidZoom:%f", scrollView.zoomScale);
}

@end