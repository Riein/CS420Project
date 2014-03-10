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
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2)];
    [self.scrollView setNeedsDisplay];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view from its nib.
    //MKMapView *mapView = [[MKMapView alloc]]
    NSNumber *latitude = [self.info objectForKey:@"Latitude"];
    NSNumber *longitude = [self.info objectForKey:@"Longitude"];
    _region.center.latitude = latitude.doubleValue;
    _region.center.longitude = longitude.doubleValue;
    _region.span.latitudeDelta = 0.02;
    _region.span.longitudeDelta = 0.02;
    _mapView.region = _region;
    NSLog(@"mapView.region set");
    
    
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
