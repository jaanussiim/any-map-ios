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
#import "JSWgsPoint.h"
#import "JSMapTilesView.h"
#import "JSGPSHandler.h"
#import "JSMapOverlaysView.h"
#import "JSMapOverlayMarker.h"
#import "JSMapOverlay.h"
#import "JSLocation.h"
#import "JSMapPos.h"
#import "Constants.h"

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
  [gpsHandler_ release];
  [mapOverlaysView_ release];
  [gpsOverlay_ release];
  [super dealloc];
}

- (void)initializeView {
  mapTilesView_ = [[JSMapTilesView alloc] initWithFrame:self.bounds];
  [mapTilesView_ setBackgroundColor:[UIColor lightGrayColor]];
  [mapTilesView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [mapTilesView_ setMapView:self];
  [self addSubview:mapTilesView_];

  gpsHandler_ = [[JSGPSHandler alloc] init];

  mapOverlaysView_ = [[JSMapOverlaysView alloc] initWithFrame:self.bounds];
  [mapOverlaysView_ setMapView:self];
  [self addSubview:mapOverlaysView_];

  JSMapOverlayMarker *marker = [[JSMapOverlayMarker alloc] initWithImage:[UIImage imageNamed:@"gps_location.png"] anchorPoint:CGPointMake(32, 64)];
  gpsOverlay_ = [[JSMapOverlay alloc] initWithMarker:marker];
  JSLocation *l = [[JSLocation alloc] init];
  [l setWgsPoint:[JSWgsPoint wgsWithLon:26.716667 lat:58.383333]];
  [gpsOverlay_ addLocation:l];
  [l release];
  [mapOverlaysView_ addOverlay:gpsOverlay_];
  [marker release];
}

- (void)setDisplayedMap:(JSBaseMap *)map {
  [mapTilesView_ setDisplayedMap:map];
}

- (void)recalculateLocations {
  [mapOverlaysView_ recalculateLocations];
}

- (void)startWithLocation:(JSWgsPoint *)point zoomLevel:(int)zoom {
  if (mappingStarted_) {
    return;
  }

  [mapTilesView_ setStartLocation:point];
  [mapTilesView_ setStartZoom:zoom];
  [mapTilesView_ start];
  [self recalculateLocations];
}

- (void)showGPSLocation {
  [gpsHandler_ addGPSConsumer:self];
}

- (void)removeGPSLocation {
  [gpsHandler_ removeGPSConsumer:self];
  [gpsOverlay_ clear];
}

- (void)didUpdateToLocation:(JSLocation *)location {
  [gpsOverlay_ clear:FALSE];
  [gpsOverlay_ addLocation:location];
  [mapTilesView_ moveToWgsPoint:location.wgsPoint];
  [mapOverlaysView_ setNeedsDisplay];
}

- (CGRect)mapViewRect {
  CGPoint offset = [mapTilesView_ contentOffset];
  CGSize size = mapTilesView_.frame.size;
  float scale = mapTilesView_.zoomScale;
  return CGRectMake(offset.x / scale, offset.y / scale, size.width / scale, size.height / scale);
}

- (JSMapPos *)pixelMapPosition:(JSWgsPoint *)wgsPoint {
  return [mapTilesView_ pixelMapPosition:wgsPoint];
}

- (void)redrawSubviews {
  [mapOverlaysView_ setNeedsDisplay];
}

- (CGFloat)zoomScale {
  return mapTilesView_.zoomScale;
}
@end