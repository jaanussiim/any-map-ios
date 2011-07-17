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

#import "EPSG3785.h"



#import "Constants.h"
#import "JSMapPos.h"
#import "JSWgsPoint.h"
#import "proj_api.h"

@implementation EPSG3785

- (id)initWithTileSize:(int)tileSize {
  self = [super initWithTileSize:tileSize projectionString:@"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"];
  
  if (self) {
    JSWgsPoint *maxWgs_ = [[JSWgsPoint alloc] initWithLon:180.000000 lat:85.051128];
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(maxWgs_.lat, maxWgs_.lon);
    [maxWgs_ release];
    point = [self transform:point];
    maxMetersX_ = point.longitude;
    maxMetersY_ = point.latitude;
    JSLog(@"maxMeters: %f - %f", maxMetersX_, maxMetersY_);
  }
  
  return self;  
}

- (id)init {
  return [self initWithTileSize:256];
}

- (void)dealloc {  
  [super dealloc];
}

- (JSWgsPoint *)mapPosToWgs:(JSMapPos *)mapPos {
  double zoomPower = log2(super.tileSize) + mapPos.zoom;
  double mapSizePx = pow(2, zoomPower);
  
  double metersX = ((mapPos.x - mapSizePx / 2) * maxMetersX_) / (mapSizePx / 2);
  double metersY = ((mapSizePx / 2 - mapPos.y) * maxMetersY_) / (mapSizePx / 2);
  
  CLLocationCoordinate2D point = CLLocationCoordinate2DMake(metersY, metersX);
  CLLocationCoordinate2D result = [self inverseTransform:point];
  
  return [[[JSWgsPoint alloc] initWithLon:result.longitude lat:result.latitude] autorelease];
}

- (JSMapPos *)wgsToMapPos:(JSWgsPoint *)wgsPoint zoomLevel:(int)zoom {
  CLLocationCoordinate2D point = CLLocationCoordinate2DMake(wgsPoint.lat, wgsPoint.lon);
  CLLocationCoordinate2D result = [self transform:point];
  
  double zoomPower = log2(super.tileSize) + zoom;
  double mapSizePx = pow(2, zoomPower);
  
  double mapX = ((result.longitude + maxMetersX_) / (maxMetersX_ * 2)) * mapSizePx;
  double mapY = ((maxMetersY_ - result.latitude) * mapSizePx) / (maxMetersY_ * 2);
  return [[[JSMapPos alloc] initWithMapX:((int) fmod(mapX, mapSizePx)) mapY:((int) fmod(mapY, mapSizePx)) zoomLevel:zoom] autorelease];
}

@end
