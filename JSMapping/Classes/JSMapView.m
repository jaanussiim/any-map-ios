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

#import "JSMapView.h"
#import "JSBaseMap.h"
#import "JSBaseMap.h"
#import "JSWgsPoint.h"
#import "JSMapTilesView.h"

@interface JSMapView (Private)

- (void)initializeView;

@end

@implementation JSMapView

@synthesize mappingStarted = mappingStarted_;


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
  [mapTilesView_ release];
  [super dealloc];
}

- (void)initializeView {
  mapTilesView_ = [[JSMapTilesView alloc] initWithFrame:self.bounds];
  [mapTilesView_ setBackgroundColor:[UIColor lightGrayColor]];
  [mapTilesView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [self addSubview:mapTilesView_];
}

- (void)setDisplayedMap:(JSBaseMap *)map {
  [mapTilesView_ setDisplayedMap:map];
}

- (void)startWithLocation:(JSWgsPoint *)point zoomLevel:(int)zoom {
  if (mappingStarted_) {
    return;
  }

  [mapTilesView_ setStartLocation:point];
  [mapTilesView_ setStartZoom:zoom];
  [mapTilesView_ start];
}

@end