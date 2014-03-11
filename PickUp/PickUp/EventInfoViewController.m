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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.frame;
    self.scrollView.ContentSize = CGSizeMake(320, 720);
    [self.scrollView setScrollEnabled:YES];
    _insideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 720)];
    [self.scrollView addSubview:self.insideView];
    [self.view addSubview:self.scrollView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 25, 320, 200)];
    NSNumber *latitude = [self.info objectForKey:@"Latitude"];
    NSNumber *longitude = [self.info objectForKey:@"Longitude"];
    _region.center.latitude = latitude.doubleValue;
    _region.center.longitude = longitude.doubleValue;
    _region.span.latitudeDelta = 0.02;
    _region.span.longitudeDelta = 0.02;
    _mapView.region = _region;
    [self.scrollView addSubview:_mapView];
    NSLog(@"mapView.region set");
    // Does not work with or without the following commented section

    _locField = [[UITextField alloc] initWithFrame:CGRectMake(92, 288, 206, 30)];
    _locField.borderStyle = UITextBorderStyleBezel;
    [_locField setEnabled:NO];
    [self.scrollView addSubview:_locField];
    UILabel *locLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 292, 67, 21)];
    locLabel.text = @"Location";
    [self.scrollView addSubview:locLabel];
    _dateField = [[UITextField alloc] initWithFrame:CGRectMake(92, 331, 206, 30)];
    _dateField.borderStyle = UITextBorderStyleBezel;
    [_dateField setEnabled:NO];
    [self.scrollView addSubview:_dateField];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 335, 67, 21)];
    dateLabel.text = @"Date";
    [self.scrollView addSubview:dateLabel];
    _timeField = [[UITextField alloc] initWithFrame:CGRectMake(92, 374, 206, 30)];
    _timeField.borderStyle = UITextBorderStyleBezel;
    [_timeField setEnabled:NO];
    [self.scrollView addSubview:_timeField];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 378, 67, 21)];
    timeLabel.text = @"Time";
    [self.scrollView addSubview:timeLabel];
    _equipField = [[UITextView alloc] initWithFrame:CGRectMake(41, 516, 239, 65)];
    [_equipField setBackgroundColor:[UIColor lightGrayColor]];
    [_equipField setEditable:NO];
    [self.scrollView addSubview:_equipField];
    UILabel *equipLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 487, 162, 21)];
    equipLabel.text = @"Required Equipment:";
    [self.scrollView addSubview:equipLabel];
    
    // Button not being added still. Need to figure out why.
    _button = [[UIButton alloc] initWithFrame:CGRectMake(115, 610, 90, 34)];
    [_button setTitle:@"Join" forState:UIControlStateApplication];
    [self.scrollView addSubview:_button];

    NSLog(@"viewDidLoad");
  
    [self.scrollView layoutSubviews];
    [self.scrollView setNeedsDisplay];
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
