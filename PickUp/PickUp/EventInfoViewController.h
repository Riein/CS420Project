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

@property (strong, nonatomic)  MKMapView *mapView;
@property MKCoordinateRegion region;

@property (strong, nonatomic)  UITextField *locField;
@property (strong, nonatomic)  UITextField *dateField;
@property (strong, nonatomic)  UITextField *timeField;
@property (strong, nonatomic)  UITextView *equipField;
@property (strong, nonatomic)  UITextView *players;
@property (strong, nonatomic)  UIButton *button;
@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIView *insideView;

@property (weak, nonatomic) NSDictionary *info;

@end
