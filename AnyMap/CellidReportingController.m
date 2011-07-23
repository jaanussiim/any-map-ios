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

#import "CellidReportingController.h"
#import "JSCellIDReportingService.h"
#import "JSMapOverlayMarker.h"
#import "JSMapOverlay.h"
#import "JSMapView.h"

@implementation CellidReportingController

@synthesize cancelButton = cancelButton_;
@synthesize saveButton = saveButton_;
@synthesize addressField = addressField_;
@synthesize mapView = mapView_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc {
  [cancelButton_ release];
  [saveButton_ release];
  [addressField_ release];
  [mapView_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.navigationItem setLeftBarButtonItem:cancelButton_];
  [self.navigationItem setRightBarButtonItem:saveButton_];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:TRUE];
}

- (IBAction)save:(id)sender {
  JSCellIDReportingService *service = [[JSCellIDReportingService alloc] initWithAddress:addressField_.text];
  JSMapOverlayMarker *marker = [[JSMapOverlayMarker alloc] initWithImage:[UIImage imageNamed:@"blue_pin.png"] anchorPoint:CGPointMake(8, 16)];
  JSMapOverlay *measurePins = [[JSMapOverlay alloc] initWithMarker:marker];
  [service setOverlay:measurePins];
  [mapView_ addMapOverlay:measurePins];
  [mapView_ addGPSConsumer:service];
  [measurePins release];
  [marker release];
  [service release];
  [self dismissModalViewControllerAnimated:TRUE];
}

@end
