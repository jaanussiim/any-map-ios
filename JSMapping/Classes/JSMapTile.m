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

#import "JSMapTile.h"
#import "JSZoomRange.h"

@implementation JSMapTile

@synthesize mapX = mapX_;
@synthesize mapY = mapY_;
@synthesize tileSize = tileSize_;
@synthesize zoom = zoom_;
@synthesize map = map_;
@synthesize imageData = imageData_;

- (id)initWithTileSize:(int)tileSize mapX:(int)x mapY:(int)y zoom:(int)zoom map:(id<JSPixelMap>)map {
  self = [super init];

  if (self) {
    tileSize_ = tileSize;
    mapX_ = x;
    mapY_ = y;
    zoom_ = zoom;
    map_ = [map retain];
  }

  return self;
}

- (void)dealloc {
  [map_ release];
  [imageData_ release];

  [super dealloc];
}

- (CGRect)locationOnMap {
  int zoomDiff = [map_ zoomRange].maxZoom - zoom_;
  return CGRectMake(mapX_ * pow(2, zoomDiff), mapY_ * pow(2, zoomDiff), tileSize_ * pow(2, zoomDiff), tileSize_ * pow(2, zoomDiff));
}

- (NSURL *)tileNetworkURL {
  return [NSURL URLWithString:[map_ buildTilePath:self]];
}

+ (JSMapTile *)mapTileWithTileSize:(int)tileSize mapX:(int)x mapY:(int)y zoom:(int)zoom map:(id<JSPixelMap>)map {
  int xMod = x % tileSize;
  int yMod = y % tileSize;
  int mapX = x - (xMod < 0 ? xMod + tileSize : xMod);
  int mapY = y - (yMod < 0 ? yMod + tileSize : yMod);
  return [[[JSMapTile alloc] initWithTileSize:tileSize mapX:mapX mapY:mapY zoom:zoom map:map] autorelease];
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[JSMapTile class]]) {
    return FALSE;
  }

  JSMapTile *other = (JSMapTile *)object;
  return mapX_ == other.mapX && mapY_ == other.mapY && tileSize_ == other.tileSize && zoom_ == other.zoom && [map_ isEqual:other.map];
}

- (NSUInteger)hash {
  NSMutableString *str = [NSMutableString string];
  [str appendFormat:@"%d:", mapX_];
  [str appendFormat:@"%d:", mapY_];
  [str appendFormat:@"%d:", tileSize_];
  [str appendFormat:@"%d:", zoom_];
  [str appendFormat:@"%d", [map_ hash]];
  return [str hash];
}

- (id)copyWithZone:(NSZone *)zone {
  JSMapTile *tile = [[JSMapTile allocWithZone:zone] initWithTileSize:tileSize_ mapX:mapX_ mapY:mapY_ zoom:zoom_ map:map_];
  [tile setImageData:[NSData dataWithData:imageData_]];
  return tile;
}

@end
