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

#import "JSMicrosoftMap.h"

#import "EPSG3785.h"
#import "JSMapTile.h"

@implementation JSMicrosoftMap

- (id)init {
  self = [super initWithProjection:[[[EPSG3785 alloc] initWithTileSize:256] autorelease] minZoom:1 maxZoom:3];

  if (self) {

  }

  return self;
}

- (NSString *)buildTilePath:(JSMapTile *)tile {
  NSMutableString *tilePath = [[NSMutableString alloc] initWithString:@"http://tiles.virtualearth.net/tiles/r"];
  int insertPoint = [tilePath length];
  int tileX = tile.mapX;
  int tileY = tile.mapY;
  int workSegmentSize = self.tileSize * 2;
  for (int z = 0; z < tile.zoom; z++) {
    int workX = tileX % workSegmentSize;
    int workY = tileY % workSegmentSize;
    [tilePath insertString:[NSString stringWithFormat:@"%d", (workX / self.tileSize + (workY / self.tileSize > 0 ? 2 : 0))] atIndex:insertPoint];

    tileX = tileX / 2;
    tileY = tileY / 2;
  }
  [tilePath appendString:@".png?g=300"];
  NSString *result = [NSString stringWithString:tilePath];
  [tilePath release];

  return result;
}

@end
