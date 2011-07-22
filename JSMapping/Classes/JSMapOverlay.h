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

@class JSLocation;
@class JSMapOverlayMarker;
@class JSMapView;
@class JSWgsPoint;

@interface JSMapOverlay : NSObject {
 @private
  JSMapOverlayMarker *marker_;
  NSArray *points_;
  NSArray *locations_;
  JSMapView *mapView_;
}

@property (nonatomic, retain) NSArray *points;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) JSMapView *mapView;

- (id)initWithMarker:(JSMapOverlayMarker *)marker;

- (void)addPoint:(JSWgsPoint *)point;
- (void)addLocation:(JSLocation *)location;

- (void)clear;
- (void)clear:(BOOL)refreshScreen;

- (void)drawRect:(CGRect)viewRect mapViewLocation:(CGRect)mapViewLocation zoomScale:(CGFloat)zoomScale;

- (void)recalculateLocations;

@end
