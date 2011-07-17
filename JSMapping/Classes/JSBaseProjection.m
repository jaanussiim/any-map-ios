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

#import "JSBaseProjection.h"

#import "Constants.h"
#import "proj_api.h"

@implementation JSBaseProjection

@synthesize tileSize = tileSize_;

- (id)initWithTileSize:(int)tileSize projectionString:(NSString *)params {
  self = [super init];
  
  if (self) {
    JSLog(@"initWithString:'%@'", params);
    tileSize_ = tileSize;
    destinationProjection_ = pj_init_plus([params UTF8String]);
    sourceProjection_ = pj_init_plus([@"+proj=latlong +ellps=WGS84" UTF8String]);
    sourceIsLatLon_ = pj_is_latlong(sourceProjection_);
    destIsLatLon_ = pj_is_latlong(destinationProjection_);
    
    if (destinationProjection_ == nil || sourceProjection_ == nil) {
      JSLog(@"Unhandled error creating projection. %d - %d", destinationProjection_ == nil, sourceProjection_ == nil);
      [self release];
      return nil;
    }
  }
  
  return self;
}

- (void)dealloc {
  if (destinationProjection_) {
    pj_free(destinationProjection_);
  }
  
  if (sourceProjection_) {
    pj_free(sourceProjection_);
  }
  
  [super dealloc];
}

- (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D)point {
  if (sourceIsLatLon_) {
		point.latitude *= DEG_TO_RAD;
		point.longitude *= DEG_TO_RAD;
	}
  
  int retCode = pj_transform(sourceProjection_, destinationProjection_, 1, 0, &point.longitude, &point.latitude, NULL);
  if (retCode != 0) {
    JSLog(@"Crapas - retCode: %d");
  }
  
  if (destIsLatLon_) {
		point.latitude *= RAD_TO_DEG;
		point.longitude *= RAD_TO_DEG;
	}
  
  return point;
}

- (CLLocationCoordinate2D)inverseTransform:(CLLocationCoordinate2D)point {
  if (destIsLatLon_) {
		point.latitude *= DEG_TO_RAD;
		point.longitude *= DEG_TO_RAD;
	}
  
  int retCode = pj_transform(destinationProjection_, sourceProjection_, 1, 0, &point.longitude, &point.latitude, NULL);
  if (retCode != 0) {
    JSLog(@"Crapas - retCode: %d", retCode);
  }
  
  if (sourceIsLatLon_) {
		point.latitude *= RAD_TO_DEG;
		point.longitude *= RAD_TO_DEG;
	}
  
  return point;
}

@end
