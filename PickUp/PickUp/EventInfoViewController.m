//
//  EventInfoViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/8/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "EventInfoViewController.h"
#import "Connection.h"
#import "PickUpAppDelegate.h"

@interface EventInfoViewController (){
    Connection *conn;
    PickUpAppDelegate *appDelegate;
}

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
    NSLog(@"eventDate:%@", self.info.eventDate);
    conn = [[Connection alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.frame;
    self.scrollView.ContentSize = CGSizeMake(320, 800);
    [self.scrollView setScrollEnabled:YES];
    _insideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 720)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 320, 720)];
    imageView.image = [UIImage imageNamed:@"gray.png"];
    
    [self.view addSubview:imageView];
    
    
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.insideView];
    [self.view addSubview:self.scrollView];
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 200)];
    //CLLocationCoordinate2D newCoord = [self geoCodeUsingAddress:self.info.location];
    //NSNumber *latitude = self.info.latitude;
    //NSNumber *longitude = self.info.longitude;
    _region.center.latitude = [self.info.latitude doubleValue];
    _region.center.longitude = [self.info.longitude doubleValue];
    _region.span.latitudeDelta = 0.02;
    _region.span.longitudeDelta = 0.02;
    _mapView.region = _region;
    
    //------------ ADDING PIN TO MAP HERE --------------------
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [self.info.latitude doubleValue];
	coordinate.longitude = [self.info.longitude doubleValue];
    [annotation setCoordinate:coordinate];
	[annotation setTitle:self.info.location]; //You can set the subtitle too
    [_mapView addAnnotation:annotation];
    [self.scrollView addSubview:_mapView];
    NSLog(@"mapView.region set");

    _locField = [[UITextField alloc] initWithFrame:CGRectMake(110, 288, 190, 30)];
    _locField.borderStyle = UITextBorderStyleBezel;
    [_locField setEnabled:NO];
    [_locField setBackgroundColor:[UIColor whiteColor]];
    [self.insideView addSubview:_locField];
    
    
    
    UILabel *locLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 292, 100, 21)];
    locLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    locLabel.textColor = [UIColor blackColor];
    locLabel.text = @"Address";

    [self.insideView addSubview:locLabel];
    _dateField = [[UITextField alloc] initWithFrame:CGRectMake(110, 331, 190, 30)];
    _dateField.borderStyle = UITextBorderStyleBezel;
    [_dateField setEnabled:NO];
    [_dateField setBackgroundColor:[UIColor whiteColor]];

    [self.insideView addSubview:_dateField];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 335, 67, 21)];
    [dateLabel setFont:[UIFont fontWithName:@"DIN Alternate Bold" size:17]];
    dateLabel.textColor = [UIColor blackColor];

    dateLabel.text = @"Date";

    [self.scrollView addSubview:dateLabel];
    _timeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 374, 190, 30)];
    _timeField.borderStyle = UITextBorderStyleBezel;
    [_timeField setEnabled:NO];
    [_timeField setBackgroundColor:[UIColor whiteColor]];

    [self.insideView addSubview:_timeField];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 378, 67, 21)];
    timeLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.text = @"Time";

    [self.scrollView addSubview:timeLabel];
    _equipField = [[UITextView alloc] initWithFrame:CGRectMake(41, 516, 243, 137)];
    [_equipField setBackgroundColor:[UIColor whiteColor]];
    [_equipField setEditable:NO];
    [self.insideView addSubview:_equipField];
    
    
    
    UILabel *equipLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 487, 190, 32)];
    equipLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    equipLabel.textColor = [UIColor blackColor];
    equipLabel.text = @"Required Equipment:";
    
    [self.insideView addSubview:equipLabel];
    _players = [[UITextView alloc] initWithFrame:CGRectMake(110, 417, 190, 67)];
    [_players setBackgroundColor:[UIColor whiteColor]];
    [_players setEditable:NO];
    [_players setBackgroundColor:[UIColor whiteColor]];

    [self.insideView addSubview:_players];
    UILabel *playersLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 421, 67, 21)];
    playersLabel.text = @"Players:";
    playersLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    playersLabel.textColor = [UIColor blackColor];


    [self.insideView addSubview:playersLabel];

    _locField.text = self.info.location;
    NSDateFormatter *day = [[NSDateFormatter alloc] init];
    [day setDateFormat:@"MMM d, yyyy"];
    NSString *date = [day stringFromDate:self.info.eventDate];
    _dateField.text = date;
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    NSString *time = [timeFormat stringFromDate:self.info.eventDate];
    _timeField.text = time;
    NSArray *ppl = [[NSArray alloc] initWithArray:self.info.players];
    NSMutableString *play = [[NSMutableString alloc] init];
    for (int i = 0; i < ppl.count; i++) {
        [play appendString:[ppl objectAtIndex:i]];
        [play appendString:@"\n"];
    }
    _players.text = play;
    
    NSArray *eq = [[NSArray alloc] initWithArray:self.info.equipment];
    NSMutableString *equip = [[NSMutableString alloc] init];
    for (int i = 0; i < eq.count; i++) {
        [equip appendString:[eq objectAtIndex:i]];
        [equip appendString:@"\n"];
    }
    _equipField.text = equip;
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(115, 680, 90, 37)];
    [_button setTitle:@"Join" forState:UIControlStateNormal];
    
    // Add this in later, change the button title if already joined
//    for (int i = 0; i < ppl.count; i++) {
//        if ([currentUser isEqual: ppl[i]]) {
//            [_button setTitle:@"Unjoin" forState:UIControlStateApplication];
//        }
//    }
    
    [_button setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];
    

    //[_button setBackgroundColor:[UIColor lightGrayColor]];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button addTarget:self
                 action:@selector(buttonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.insideView addSubview:_button];

    NSLog(@"viewDidLoad");
  
    [self.scrollView layoutSubviews];
    [self.scrollView setNeedsDisplay];
    [self.view setNeedsDisplay];
    self.scrollView.delaysContentTouches = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}




-(void)buttonPressed:(id)sender{
    NSLog(@"button pressed");
    // Add user to list
    // Send update to server
    if ([_button.currentTitle isEqual: @"Join"]) {
        NSDictionary *params = @{@"event_id" : self.info.event_id, @"username" : appDelegate.user};
        
        // Locking current thread until modEvent is complete
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [queue addOperation:[[NSInvocationOperation alloc] initWithTarget:conn selector:@selector(modEvent:) object:params]];
        
        [queue waitUntilAllOperationsAreFinished];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Event"
                                                        message:@"You have joined this event"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [_button setTitle:@"Unjoin" forState:UIControlStateNormal];
    }
    else{
        NSDictionary *params = @{@"event_id" : self.info.event_id, @"username" : appDelegate.user};
        
        // Locking current thread until modEvent is complete
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [queue addOperation:[[NSInvocationOperation alloc] initWithTarget:conn selector:@selector(modEvent:) object:params]];
        
        [queue waitUntilAllOperationsAreFinished];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Event"
                                                        message:@"You have removed yourself from his event"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        [_button setTitle:@"Join" forState:UIControlStateNormal];
    }
}

@end
