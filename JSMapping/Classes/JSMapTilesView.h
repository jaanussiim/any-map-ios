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

@class JSBaseMap;
@class JSMapTilesRenderer;
@class JSWgsPoint;
@class JSMapPos;
@class JSMapView;

@interface JSMapTilesView : UIScrollView <UIScrollViewDelegate> {
 @private
  JSMapTilesRenderer *tilesRenderView_;
  JSBaseMap *displayedMap_;
  JSWgsPoint *startLocation_;
  int startZoom_;
  JSMapView *mapView_;
}
@property (nonatomic, retain) JSBaseMap *displayedMap;
@property (nonatomic, retain) JSMapTilesRenderer *tilesRenderView;
@property (nonatomic, retain) JSWgsPoint *startLocation;
@property (nonatomic, assign) int startZoom;
@property (nonatomic, assign) JSMapView *mapView;

- (void)start;
- (JSMapPos *)pixelMapPosition:(JSWgsPoint *)point;

- (void)moveToWgsPoint:(JSWgsPoint *)point;
@end