//
//  EventInfoViewController.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/8/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventInfoViewController : UIViewController

@property (assign, nonatomic) IBOutlet MKMapView *mapView;
@property MKCoordinateRegion region;

@property (weak, nonatomic) IBOutlet UITextField *locField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UITextView *equipField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) NSDictionary *info;

- (IBAction)joinButton:(id)sender;

@end
