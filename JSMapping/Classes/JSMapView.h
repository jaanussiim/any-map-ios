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

#import "JSGPSConsumer.h"

@class JSBaseMap;
@class JSWgsPoint;
@class JSMapTilesView;
@class JSGPSHandler;
@class JSMapOverlaysView;
@class JSMapOverlay;
@class JSMapPos;

@interface JSMapView : UIView <JSGPSConsumer> {
 @private
  BOOL mappingStarted_;
  JSMapTilesView *mapTilesView_;
  JSGPSHandler *gpsHandler_;
  JSMapOverlaysView *mapOverlaysView_;
  JSMapOverlay *gpsOverlay_;
}

@property (nonatomic, readonly) BOOL mappingStarted;

- (void)setDisplayedMap:(JSBaseMap *)map;
- (void)startWithLocation:(JSWgsPoint *)point zoomLevel:(int)zoom;
- (void)showGPSLocation;
- (void)removeGPSLocation;

- (CGRect)mapViewRect;
- (JSMapPos *)pixelMapPosition:(JSWgsPoint *)point;

- (void)redrawSubviews;

- (CGFloat)zoomScale;
@end