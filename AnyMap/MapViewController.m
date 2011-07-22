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

#import "MapViewController.h"
#import "JSMapView.h"
#import "JSWgsPoint.h"
#import "JSMicrosoftMap.h"


@implementation MapViewController

@synthesize mapView = mapView_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc {
  [mapView_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self setMapView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (![mapView_ mappingStarted]) {
    [mapView_ setDisplayedMap:[[[JSMicrosoftMap alloc] init] autorelease]];
    [mapView_ startWithLocation:[JSWgsPoint wgsWithLon:26.716667 lat:58.383333] zoomLevel:13];
  }
}

- (IBAction)toggleGPSState:(id)sender {
  UIBarButtonItem *button = (UIBarButtonItem *)sender;
  [button setStyle:(button.style == UIBarButtonItemStyleDone ? UIBarButtonItemStyleBordered : UIBarButtonItemStyleDone)];

  if (button.style == UIBarButtonItemStyleDone) {
    [mapView_ showGPSLocation];
  } else {
    [mapView_ removeGPSLocation];
  }
}


@end