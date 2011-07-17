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

#import "JSBaseMap.h"

#import "JSZoomRange.h"

@implementation JSBaseMap

@synthesize zoomRange = zoomRange_;

- (id)initWithProjection:(id <JSProjection>)projection minZoom:(int)minZoom maxZoom:(int)maxZoom {
  self = [super init];

  if (self) {
    projection_ = [projection retain];
    zoomRange_ = [[JSZoomRange alloc] initWithMinZoom:minZoom maxZoom:maxZoom];
  }

  return self;
}

- (void)dealloc {
  [projection_ release];
  [zoomRange_ release];

  [super dealloc];
}

- (JSMapPos *)wgsToMapPos:(JSWgsPoint *)wgsPoint zoomLevel:(int)zoom {
  return [projection_ wgsToMapPos:wgsPoint zoomLevel:zoom];
}

- (JSWgsPoint *)mapPosToWgs:(JSMapPos *)mapPos {
  return [projection_ mapPosToWgs:mapPos];
}

- (int)tileSize {
  return [projection_ tileSize];
}

- (NSString *)buildTilePath:(JSMapTile *)tile {
  [NSException raise:NSInternalInconsistencyException
              format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
  return nil;
}

- (CGRect)tileMapBoundsOnZoom:(int)zoomLevel {
  double edge = pow(2, log2([self tileSize]) + zoomLevel);
  return CGRectMake(0, 0, edge, edge);
}

@end
