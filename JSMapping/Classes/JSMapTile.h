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

#import "JSPixelMap.h"

@class JSMapPos;

@interface JSMapTile : NSObject <NSCopying> {
 @private
  int tileSize_;
  int mapX_;
  int mapY_;
  int zoom_;
  id<JSPixelMap> map_;
  NSData *imageData_;
}

@property (nonatomic, readonly) int mapX;
@property (nonatomic, readonly) int mapY;
@property (nonatomic, readonly) int tileSize;
@property (nonatomic, readonly) int zoom;
@property (nonatomic, readonly) id<JSPixelMap> map;
@property (nonatomic, retain) NSData *imageData;

- (id)initWithTileSize:(int)tileSize mapX:(int)x mapY:(int)y zoom:(int)zoom map:(id<JSPixelMap>)map;
- (CGRect)locationOnMap;
- (NSURL *)tileNetworkURL;

+ (JSMapTile *)mapTileWithTileSize:(int)tileSize mapX:(int)x mapY:(int)y zoom:(int)zoom map:(id<JSPixelMap>)map;

@end
