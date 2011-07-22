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

#import <QuartzCore/CATiledLayer.h>
#import "JSMapTilesRenderer.h"
#import "JSBaseMap.h"
#import "Constants.h"
#import "JSZoomRange.h"
#import "JSMapTile.h"
#import "JSTilePullRequest.h"
#import "ASIDownloadCache.h"

@interface JSMapTilesRenderer (Private)

- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col;
- (int)zoomLevelForScale:(CGFloat)scale;

@end

@implementation JSMapTilesRenderer

+ (Class)layerClass {
  return [CATiledLayer class];
}

- (id)initWithMap:(JSBaseMap *)map {
  CGSize contentSize = [map contentSize];
  self = [super initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];

  if (self != nil) {
    displayedMap_ = [map retain];
    CATiledLayer *tiledLayer = (CATiledLayer *) [self layer];
    [tiledLayer setTileSize:CGSizeMake([map tileSize], [map tileSize])];
    int levelOfDetails = [map levelsOfDetails] + 1;
    JSLog(@"level of details:%d", levelOfDetails);
    [tiledLayer setLevelsOfDetail:(size_t) levelOfDetails];
    zoomRange_ = [[map zoomRange] retain];
    zoomLevelScales_ = [[NSMutableArray alloc] initWithCapacity:levelOfDetails];
    for (int i = 0; i < levelOfDetails; i++) {
      [zoomLevelScales_ addObject:[NSNumber numberWithFloat:(1 / pow(2, i))]];
    }
    [self setOpaque:FALSE];
  }

  return self;
}

- (void)dealloc {
  [zoomRange_ release];
  [zoomLevelScales_ release];
  [displayedMap_ release];
  [super dealloc];
}

- (void)drawRect:(CGRect)rect {
  JSLog(@"drawRect:%@", NSStringFromCGRect(rect));
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGFloat scale = CGContextGetCTM(context).a;

  CATiledLayer *tiledLayer = (CATiledLayer *) [self layer];
  CGSize tileSize = tiledLayer.tileSize;

  tileSize.width /= scale;
  tileSize.height /= scale;

  // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
  int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
  int lastCol = floorf((CGRectGetMaxX(rect) - 1) / tileSize.width);
  int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
  int lastRow = floorf((CGRectGetMaxY(rect) - 1) / tileSize.height);

  for (int row = firstRow; row <= lastRow; row++) {
    for (int col = firstCol; col <= lastCol; col++) {
      UIImage *tile = [self tileForScale:scale row:row col:col];
      CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row, tileSize.width, tileSize.height);

      // if the tile would stick outside of our bounds, we need to truncate it so as to avoid
      // stretching out the partial tiles at the right and bottom edges
      tileRect = CGRectIntersection(self.bounds, tileRect);

      if (tile != nil) {
        [tile drawInRect:tileRect];
      }

      if (true) {
        [[UIColor whiteColor] set];
        CGContextSetLineWidth(context, 6.0 / scale);
        CGContextStrokeRect(context, tileRect);
      }
    }
  }
}

- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col {
  JSLog(@"Tile for scale:%f row:%d col:%d", scale, row, col);

  int mapZoomLevel = [self zoomLevelForScale:scale];

  JSLog(@"map tile data - zoom:%d", mapZoomLevel);

  JSMapTile *tile = [JSMapTile mapTileWithTileSize:256 mapX:col * 256 mapY:row * 256 zoom:mapZoomLevel map:displayedMap_];
  JSLog(@"tilePath: %@", [tile tileNetworkURL]);

  //TODO jaanus: this is a hack
  NSData *imageData = [[ASIDownloadCache sharedCache] cachedResponseDataForURL:[tile tileNetworkURL]];
  if (imageData != nil) {
    JSLog(@"data from cache");
    return [UIImage imageWithData:imageData];
  }

  NSURL *tileUrl = [tile tileNetworkURL];
  __block JSTilePullRequest *request = [JSTilePullRequest requestWithURL:tileUrl];
  [request setPulledTile:tile];

  [request setCompletionBlock:^{
    NSData *responseData = [request responseData];
    JSMapTile *tile = ((JSTilePullRequest *)request).pulledTile;
    [tile setImageData:responseData];
    JSLog(@"did pull %d bytes for %@", [responseData length], tile);
    [self setNeedsDisplayInRect:[tile locationOnMap]];
  }];
  [request setFailedBlock:^{
    JSMapTile *tile = ((JSTilePullRequest *)request).pulledTile;
    JSLog(@"pull error on: %@", tile);
  }];
  [request startAsynchronous];

  return nil;
}

- (int)zoomLevelForScale:(CGFloat)scale {
  for (int i = 1; i < [zoomLevelScales_ count]; i++) {
    if (scale > [[zoomLevelScales_ objectAtIndex:i] floatValue]) {
      return zoomRange_.maxZoom - i + 1;
    }
  }

  return zoomRange_.minZoom;
}

@end