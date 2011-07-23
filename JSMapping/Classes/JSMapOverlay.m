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

#import "JSMapOverlay.h"

#import "Constants.h"
#import "JSLocation.h"
#import "JSMapPos.h"
#import "JSMapView.h"
#import "JSMapOverlayMarker.h"

@interface JSMapOverlay (Private)

- (void)calculateMapPosition:(JSLocation *)location;

@end

@implementation JSMapOverlay

@synthesize points = points_;
@synthesize locations = locations_;
@synthesize mapView = mapView_;

- (id)initWithMarker:(JSMapOverlayMarker *)marker {
  self = [super init];

  if (self != nil) {
    marker_ = [marker retain];
    [self setPoints:[NSArray array]];
    [self setLocations:[NSArray array]];
  }

  return self;
}

- (void)dealloc {
  [marker_ release];
  [points_ release];
  [locations_ release];
  [mapView_ release];

  [super dealloc];
}

- (void)drawRect:(CGRect)viewRect mapViewLocation:(CGRect)mapViewLocation zoomScale:(CGFloat)zoomScale {
  for (JSLocation *l in locations_) {
    JSMapPos *locationPos = l.mapPos;
    CGPoint anchor = marker_.anchorPoint;
    CGRect markerRectOnMap = CGRectMake(locationPos.x - anchor.x / zoomScale, locationPos.y - anchor.y / zoomScale, marker_.markerSize.width / zoomScale, marker_.markerSize.height / zoomScale);

    if (!CGRectIntersectsRect(markerRectOnMap, mapViewLocation)) {
      continue;
    }

    CGRect markerOnMapView = CGRectMake((locationPos.x - mapViewLocation.origin.x) * zoomScale - anchor.x, (locationPos.y - mapViewLocation.origin.y) * zoomScale - anchor.y, marker_.markerSize.width, marker_.markerSize.height);
    [marker_.markerImage drawInRect:markerOnMapView];
  }
}

- (void)addPoint:(JSWgsPoint *)point {
  NSMutableArray *nextPoints = [NSMutableArray arrayWithArray:points_];
  [nextPoints addObject:point];
  [self setPoints:[NSArray arrayWithArray:nextPoints]];
}

- (void)addLocation:(JSLocation *)location {
  NSMutableArray *nextLocations = [NSMutableArray arrayWithArray:locations_];
  [self calculateMapPosition:location];
  [nextLocations addObject:location];
  [self setLocations:[NSArray arrayWithArray:nextLocations]];
  [mapView_ redrawSubviews];
}

- (void)clear {
  [self clear:TRUE];
}

- (void)clear:(BOOL)refreshScreen {
  [self setPoints:[NSArray array]];
  [self setLocations:[NSArray array]];
  if (refreshScreen) {
    [mapView_ redrawSubviews];
  }
}

- (void)recalculateLocations {
  for (JSLocation *l in locations_) {
    [self calculateMapPosition:l];
  }
}

- (void)calculateMapPosition:(JSLocation *)location {
  [location setMapPos:[mapView_ pixelMapPosition:location.wgsPoint]];
}

@end
