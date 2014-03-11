//
//  EventInfoViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/8/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "EventInfoViewController.h"

@interface EventInfoViewController ()

@end

@implementation EventInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//-(void)loadView{
//    //[super viewDidAppear:animated];
//    [self.scrollView setScrollEnabled:YES];
//    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2)];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.frame;
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2)];
    [self.scrollView setScrollEnabled:YES];
    [self.view addSubview:self.scrollView];
    [self.scrollView layoutSubviews];
    [self.scrollView setNeedsDisplay];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _mapView = [[MKMapView alloc] init];
    NSNumber *latitude = [self.info objectForKey:@"Latitude"];
    NSNumber *longitude = [self.info objectForKey:@"Longitude"];
    _region.center.latitude = latitude.doubleValue;
    _region.center.longitude = longitude.doubleValue;
    _region.span.latitudeDelta = 0.02;
    _region.span.longitudeDelta = 0.02;
    _mapView.region = _region;
    NSLog(@"mapView.region set");
//    [self.scrollView addSubview:_mapView];
//    _locField = [[UITextField alloc] initWithFrame:CGRectMake(114, 172, 206, 30)];
//    [self.scrollView addSubview:_locField];
//    _dateField = [[UITextField alloc] init];
//    [self.scrollView addSubview:_dateField];
//    _timeField = [[UITextField alloc] init];
//    [self.scrollView addSubview:_timeField];
//    _equipField = [[UITextView alloc] init];
//    [self.scrollView addSubview:_equipField];
//    _button = [[UIButton alloc] init];
//    [self.scrollView addSubview:_button];
//    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 50)];
//    testLabel.text = @"testing";
//    [self.scrollView addSubview:testLabel];
    NSLog(@"viewDidLoad");
  
    [self.view sendSubviewToBack:_scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButton:(id)sender {
//    if (_joined) {
//        self.joined = NO;
//        [sender setTitle:@"Join"];
//        // Update the DB to show no longer joined
//    }
//    else{
//        self.joined = YES;
//        [sender setTitle:@"Unjoin"];
//        // Update the DB to show attending
//    }
}

@end
