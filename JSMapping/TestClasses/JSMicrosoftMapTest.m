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

#import <GHUnitIOS/GHTestCase.h>

#import "JSMapPos.h"
#import "JSMapTile.h"
#import "JSMicrosoftMap.h"
#import "JSWgsPoint.h"

@interface JSMicrosoftMapTest : GHTestCase {
  JSMicrosoftMap *map_;
}
@end


@implementation JSMicrosoftMapTest

- (void)setUp {
  map_ = [[JSMicrosoftMap alloc] init];
}

- (void)testTartuTile {
  JSWgsPoint *tartu = [JSWgsPoint wgsWithLon:26.717 lat:58.282];
  JSMapPos *tartuPos = [map_ wgsToMapPos:tartu zoomLevel:17];
  JSMapTile *tile = [JSMapTile mapTileWithTileSize:256 mapX:tartuPos.x mapY:tartuPos.y zoom:17 map:map_];
  NSString *tilePath = [map_ buildTilePath:tile];
  GHAssertEqualStrings(@"http://tiles.virtualearth.net/tiles/r12012210313331133.png?g=300", tilePath, @"Wrong tile path");
}

- (void)tearDown {
  [map_ release];
}

@end
