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

#import "EPSG3785.h"
#import "JSMapPos.h"
#import "JSWgsPoint.h"

@interface EPSG3785Test : GHTestCase { 
  EPSG3785 *projection_;
  NSArray *delta_;
}

@end


@implementation EPSG3785Test

- (void)setUp {
  [super setUp];
  
  projection_ = [[EPSG3785 alloc] initWithTileSize:256];
  
  delta_ = [[NSArray alloc] initWithObjects:
            [NSNumber numberWithDouble:1.41], //zoom 0
            [NSNumber numberWithDouble:0.71], //zoom 1
            [NSNumber numberWithDouble:0.36], //zoom 2
            [NSNumber numberWithDouble:0.18], //zoom 3
            [NSNumber numberWithDouble:0.088], //zoom 4
            [NSNumber numberWithDouble:0.044], //zoom 5
            [NSNumber numberWithDouble:0.022], //zoom 6
            [NSNumber numberWithDouble:0.011], //zoom 7
            [NSNumber numberWithDouble:0.0055], //zoom 8
            [NSNumber numberWithDouble:0.0028], //zoom 9
            [NSNumber numberWithDouble:0.0014], //zoom 10
            [NSNumber numberWithDouble:0.00069], //zoom 11
            [NSNumber numberWithDouble:0.00035], //zoom 12
            [NSNumber numberWithDouble:0.00018], //zoom 13
            [NSNumber numberWithDouble:0.000086], //zoom 14
            [NSNumber numberWithDouble:0.000043], //zoom 15
            [NSNumber numberWithDouble:0.000021], //zoom 16
            nil];
}

- (void)test256LeftUpLocation {
  JSWgsPoint *minLocation_ = [[JSWgsPoint alloc] initWithLon:-180.000000 lat:85.051128];
  for (int i = 0; i < 17; i++) {
    GHTestLog(@"Running %d", i);
    JSMapPos *pos = [projection_ wgsToMapPos:minLocation_ zoomLevel:i];
    
    GHAssertNotNil(pos, @"No pos created on zoom level: %d", i);
    
    GHAssertEquals(0, pos.x, @"Pos x should be zero, but was %d", pos.x);
    GHAssertEquals(pos.x, pos.y, @"Pos x should have equal pos y -- %d, %d", pos.x, pos.y);
    
    JSWgsPoint *backToZero = [projection_ mapPosToWgs:pos];
    GHAssertNotNil(backToZero, @"No wgs point created on zoom level: %d", i);
    
    GHAssertEquals(minLocation_.lon, backToZero.lon, @"Lon not right: %f - %f", minLocation_.lon, backToZero.lon);
    GHAssertTrue(fabs(minLocation_.lat - backToZero.lat) < 0.0000001, @"Lat not right: %f - %f", minLocation_.lat, backToZero.lat);
  }
  
  [minLocation_ release];
}

- (void)test256RightDownLocation {
  JSWgsPoint *maxLocation_ = [[JSWgsPoint alloc] initWithLon:179.999999 lat:-85.051127];
  
  for (int i = 0; i < 17; i++) {
    GHTestLog(@"Running %d", i);
    JSMapPos *pos = [projection_ wgsToMapPos:maxLocation_ zoomLevel:i];
    
    GHAssertEquals((int)pow(2, 8 + i) - 1, pos.x, @"Pos x should be %d, but was %d", pow(2, 8 + i) - 1, pos.x);
    GHAssertEquals(pos.x, pos.y, @"Pos x should have equal pos y -- %d, %d", pos.x, pos.y);
    
    JSWgsPoint *backToZero = [projection_ mapPosToWgs:pos];
    double delta = [[delta_ objectAtIndex:i] doubleValue];
    GHAssertTrue(fabs(maxLocation_.lon-backToZero.lon) < delta, @"Run %d, Lon not right: %f - %f. delta: %f", i, maxLocation_.lon, backToZero.lon, (maxLocation_.lon - backToZero.lon));
    GHAssertTrue(fabs(maxLocation_.lat - backToZero.lat) < delta / 10, @"Lat not right: %f - %f", maxLocation_.lat, backToZero.lat);    
  }
  
  [maxLocation_ release];
}

- (void)test256CenterLocation {
  JSWgsPoint *zeroLocation_ = [[JSWgsPoint alloc] initWithLon:0.0 lat:0.0];
  
  for (int i = 0; i < 17; i++) {
    GHTestLog(@"Running %d", i);
    JSMapPos *pos = [projection_ wgsToMapPos:zeroLocation_ zoomLevel:i];
    
    GHAssertEquals((int)pow(2, 8 + i) / 2, pos.x, @"Pos x should be %d, but was %d", pow(2, 8 + i) / 2, pos.x);
    GHAssertEquals(pos.x, pos.y, @"Pos x should have equal pos y -- %d, %d", pos.x, pos.y);
    
    JSWgsPoint *back = [projection_ mapPosToWgs:pos];
    GHAssertEquals(zeroLocation_.lon, back.lon, @"Lon not right: %f - %f", zeroLocation_.lon, back.lon);
    GHAssertEquals(zeroLocation_.lat, back.lat, @"Lat not right: %f - %f", zeroLocation_.lat, back.lat);
  }
  
  [zeroLocation_ release];
}

- (void)test256RightUpLocation {
  JSWgsPoint *wgsMaxValue_ = [[JSWgsPoint alloc] initWithLon:179.999999 lat:85.051127];
  
  for (int i = 0; i < 17; i++) {
    GHTestLog(@"Running %d", i);
    JSMapPos *pos = [projection_ wgsToMapPos:wgsMaxValue_ zoomLevel:i];
    
    GHAssertEquals((int)pow(2, 8 + i) - 1, pos.x, @"Pos x should be %d, but was %d", pow(2, 8 + i) - 1, pos.x);
    GHAssertEquals(0, pos.y, @"Pos shoule be zero, but is -- %d", pos.y);
    
    JSWgsPoint *back = [projection_ mapPosToWgs:pos];
    double delta = [[delta_ objectAtIndex:i] doubleValue];
    GHAssertTrue(fabs(wgsMaxValue_.lon - back.lon) < delta, @"Lon not right: %f - %f", wgsMaxValue_.lon, back.lon);
    GHAssertTrue(fabs(wgsMaxValue_.lat - back.lat) < 0.000001, @"Lat not right: %f - %f", wgsMaxValue_.lat, back.lat);
  }
  
  [wgsMaxValue_ release];
}

- (void)test256TallinnLocation {
  JSWgsPoint *tallinn = [[JSWgsPoint alloc] initWithLon:24.765480 lat:59.437420];
  int TALLINN_COORDINATES[18][2] = { { 145, 75 }, //zoom 0
    { 291, 150 }, //zoom 1
    { 582, 300 }, //zoom 2
    { 1164, 601 }, //zoom 3
    { 2329, 1202 }, //zoom 4
    { 4659, 2404 }, //zoom 5
    { 9319, 4808 }, //zoom 6
    { 18638, 9617 }, //zoom 7
    { 37276, 19234 }, //zoom 8
    { 74552, 38469 }, //zoom 9
    { 149105, 76938 }, //zoom 10
    { 298211, 153877 }, //zoom 11
    { 596422, 307755 }, //zoom 12
    { 1192845, 615511 }, //zoom 13
    { 2385690, 1231023 }, //zoom 14
    { 4771381, 2462046 }, //zoom 15
    { 9542763, 4924093 }, //zoom 16
    { 19085526, 9848187 } //zoom 17
  };
  
  for (int i = 0; i < 17; i++) { 
    JSMapPos *pos = [projection_ wgsToMapPos:tallinn zoomLevel:i];
    
    GHAssertEquals(TALLINN_COORDINATES[i][0], pos.x, @"Run %d. x not right", i);
    GHAssertEquals(TALLINN_COORDINATES[i][1], pos.y, @"Run %d. Y not right", i);
    
    JSWgsPoint *back = [projection_ mapPosToWgs:pos];
    double delta = [[delta_ objectAtIndex:i] doubleValue];
    GHAssertTrue(fabs(tallinn.lon - back.lon) < delta, @"Run %d. lon not right. %f - %f", i, tallinn.lon, back.lon);
    GHAssertTrue(fabs(tallinn.lat - back.lat) < delta, @"Run %d. lat not right. %f - %f", i, tallinn.lat, back.lat);
  }
  
  [tallinn release];
}

- (void)test256WDCLocation {
  JSWgsPoint *wdc = [[JSWgsPoint alloc] initWithLon:-77.036666 lat:38.895000];
  int WASHINGTON_DC_COORDINATES[18][2] = { { 73, 97 }, { 146, 195 }, { 292, 391 }, { 585, 783 },
    { 1171, 1566 }, { 2342, 3133 }, { 4685, 6267 }, { 9371, 12535 }, { 18743, 25071 }, { 37487, 50142 }, { 74975, 100284 },
    { 149951, 200568 }, { 299902, 401137 }, { 599804, 802274 }, { 1199609, 1604548 }, { 2399219, 3209097 }, { 4798439, 6418194 },
    { 9596878, 12836388 } };
  
  for (int i = 0; i < 17; i++) {
    JSMapPos *pos = [projection_ wgsToMapPos:wdc zoomLevel:i];
    
    GHAssertEquals(WASHINGTON_DC_COORDINATES[i][0], pos.x, @"Run %d. x not right", i);
    GHAssertEquals(WASHINGTON_DC_COORDINATES[i][1], pos.y, @"Run %d. Y not right", i);
    
    JSWgsPoint *back = [projection_ mapPosToWgs:pos];
    double delta = [[delta_ objectAtIndex:i] doubleValue];
    GHAssertTrue(fabs(wdc.lon - back.lon) < delta, @"Run %d. lon not right. %f - %f", i, wdc.lon, wdc.lon);
    GHAssertTrue(fabs(wdc.lat - back.lat) < delta, @"Run %d. lat not right. %f - %f", i, wdc.lat, wdc.lat);    
  }
  [wdc release];
}

- (void)tearDown {
  [projection_ release];
  [delta_ release];
  
  [super tearDown];
}

@end
