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

#import "JSMapOverlaysView.h"
#import "JSMapOverlay.h"
#import "JSGPSConsumer.h"
#import "JSMapView.h"
#import "Constants.h"

@implementation JSMapOverlaysView

@synthesize overlays = overlays_;
@synthesize mapView = mapView_;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setOverlays:[NSArray array]];
    [self setOpaque:FALSE];
    [self setUserInteractionEnabled:FALSE];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGRect mapViewLocation = [mapView_ mapViewRect];
  CGFloat scale = [mapView_ zoomScale];
  for (JSMapOverlay *o in overlays_) {
    [o drawRect:rect mapViewLocation:mapViewLocation zoomScale:scale];
  }
}

- (void)dealloc {
  [overlays_ release];

  [super dealloc];
}

- (void)addOverlay:(JSMapOverlay *)mapOverlay {
  [mapOverlay setMapView:mapView_];
  NSMutableArray *nextOverlays = [NSMutableArray arrayWithArray:overlays_];
  [nextOverlays addObject:mapOverlay];
  [self setOverlays:[NSArray arrayWithArray:nextOverlays]];
  [self setNeedsLayout];
}

- (void)removeOverlay:(JSMapOverlay *)mapOverlay {
  NSMutableArray *nextOverlays = [NSMutableArray arrayWithArray:overlays_];
  [nextOverlays removeObject:mapOverlay];
  [self setOverlays:[NSArray arrayWithArray:nextOverlays]];
  [self setNeedsLayout];
}

- (void)recalculateLocations {
  for (JSMapOverlay *o in overlays_) {
    [o recalculateLocations];
  }
}

@end
