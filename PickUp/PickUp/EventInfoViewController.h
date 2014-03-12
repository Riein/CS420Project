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

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKCoordinateRegion region;

@property (strong, nonatomic) IBOutlet UITextField *locField;
@property (strong, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) IBOutlet UITextField *timeField;
@property (strong, nonatomic) IBOutlet UITextView *equipField;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *insideView;

@property (weak, nonatomic) NSDictionary *info;

@end
