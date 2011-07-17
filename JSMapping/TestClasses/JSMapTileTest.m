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

#import <GHUnitIOS/GHUnit.h>

#import "JSMapTile.h"
#import "JSMicrosoftMap.h"
#import "JSOpenStreetMap.h"

@interface JSMapTileTest : GHTestCase {
  JSMicrosoftMap *map_;
}

- (void)tileCalculationTestWithMapX:(int)mapX mapY:(int)mapY expectedX:(int)x expectedY:(int)y;

@end


@implementation JSMapTileTest

- (void)setUp {
  map_ = [[JSMicrosoftMap alloc] init];
}

- (void)testEqualsAndHash {
  JSMapTile *one = [JSMapTile mapTileWithTileSize:256 mapX:0 mapY:0 zoom:0 map:map_];
  JSMapTile *two = [JSMapTile mapTileWithTileSize:256 mapX:0 mapY:0 zoom:0 map:map_];
  JSMapTile *three = [JSMapTile mapTileWithTileSize:64 mapX:0 mapY:0 zoom:0 map:map_];
  JSMapTile *four = [JSMapTile mapTileWithTileSize:256 mapX:256 mapY:0 zoom:0 map:map_];
  JSMapTile *five = [JSMapTile mapTileWithTileSize:256 mapX:0 mapY:256 zoom:0 map:map_];
  JSMapTile *six = [JSMapTile mapTileWithTileSize:256 mapX:0 mapY:0 zoom:10 map:map_];
  JSMapTile *seven = [JSMapTile mapTileWithTileSize:256 mapX:0 mapY:0 zoom:0 map:[[[JSOpenStreetMap alloc] init] autorelease]];

  GHAssertTrue([one isEqual:one], @"one should equal one");
  GHAssertTrue([one isEqual:two], @"one should equal two");
  GHAssertFalse([one isEqual:three], @"one should not equal three");
  GHAssertFalse([one isEqual:four], @"one should not equal four");
  GHAssertFalse([one isEqual:five], @"one should not equal five");
  GHAssertFalse([one isEqual:six], @"one should not equal six");
  GHAssertFalse([one isEqual:seven], @"one should not equal seven");

  GHAssertEquals([one hash], [one hash], @"Hash should be same for one : one");
  GHAssertEquals([one hash], [two hash], @"Hash should be same for one : two");
  GHAssertNotEquals([one hash], [three hash], @"Hash should be different for one : three");
  GHAssertNotEquals([one hash], [seven hash], @"Hash should be different for one : seven");
}

- (void)testTilesCalculation {
  [self tileCalculationTestWithMapX:0 mapY:0 expectedX:0 expectedY:0];
  [self tileCalculationTestWithMapX:128 mapY:128 expectedX:0 expectedY:0];
  [self tileCalculationTestWithMapX:-128 mapY:-128 expectedX:-256 expectedY:-256];
  [self tileCalculationTestWithMapX:-256 mapY:-256 expectedX:-256 expectedY:-256];
  [self tileCalculationTestWithMapX:-256 mapY:128 expectedX:-256 expectedY:0];
  [self tileCalculationTestWithMapX:-14 mapY:-154 expectedX:-256 expectedY:-256];
  [self tileCalculationTestWithMapX:242 mapY:-154 expectedX:0 expectedY:-256];
  [self tileCalculationTestWithMapX:-300 mapY:28 expectedX:-512 expectedY:0];
}

- (void)tileCalculationTestWithMapX:(int)mapX mapY:(int)mapY expectedX:(int)x expectedY:(int)y {
  JSMapTile *tile = [JSMapTile mapTileWithTileSize:256 mapX:mapX mapY:mapY zoom:0 map:map_];
  GHAssertEquals(x, tile.mapX, @"Wrong tile x. %d vs %d", x, tile.mapX);
  GHAssertEquals(y, tile.mapY, @"Wrong tile y");
}

- (void)tearDown {
  [map_ release];
}

@end
