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
    
    // Create link to appDelegate and connection
    appDelegate = [[UIApplication sharedApplication] delegate];
    conn = [[Connection alloc] init];
    
    // Show and enable delete button if current user is the host
    if ( [appDelegate.user isEqualToString:self.info.host] ) {
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteEvent)];
        self.navigationItem.rightBarButtonItem = deleteButton;
    }
    
    // Create the scroll view, image view, and inside view
    
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
    
    // Initialize the map view and set it's coordinates and zoom
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 200)];
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
	[annotation setTitle:self.info.eventName]; //You can set the subtitle too
    [annotation setSubtitle:self.info.location];
    [_mapView addAnnotation:annotation];
    [self.scrollView addSubview:_mapView];

    // Creating text field to hold the address
    _locField = [[UITextField alloc] initWithFrame:CGRectMake(110, 288, 190, 30)];
    _locField.borderStyle = UITextBorderStyleBezel;
    [_locField setEnabled:NO];
    [_locField setBackgroundColor:[UIColor whiteColor]];
    [self.insideView addSubview:_locField];
    
    // Add a label for the address
    UILabel *locLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 292, 100, 21)];
    locLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    locLabel.textColor = [UIColor blackColor];
    locLabel.text = @"Address";
    [self.insideView addSubview:locLabel];
    
    // Create text field to hold the date
    _dateField = [[UITextField alloc] initWithFrame:CGRectMake(110, 331, 190, 30)];
    _dateField.borderStyle = UITextBorderStyleBezel;
    [_dateField setEnabled:NO];
    [_dateField setBackgroundColor:[UIColor whiteColor]];
    [_dateField setText:[self.info.eventDate substringToIndex:12]];
    [self.insideView addSubview:_dateField];
    
    // Add a label for the date
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 335, 67, 21)];
    [dateLabel setFont:[UIFont fontWithName:@"DIN Alternate Bold" size:17]];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.text = @"Date";
    [self.scrollView addSubview:dateLabel];
    
    // Create a text field to hold the time
    _timeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 374, 190, 30)];
    _timeField.borderStyle = UITextBorderStyleBezel;
    [_timeField setEnabled:NO];
    [_timeField setBackgroundColor:[UIColor whiteColor]];
    [_timeField setText:[self.info.eventDate substringFromIndex:13]];
    [self.insideView addSubview:_timeField];
    
    // Add a label for the time
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 378, 67, 21)];
    timeLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.text = @"Time";
    [self.scrollView addSubview:timeLabel];
    
    // Create a text view to hold the equipment list
    _equipField = [[UITextView alloc] initWithFrame:CGRectMake(41, 516, 243, 137)];
    [_equipField setBackgroundColor:[UIColor whiteColor]];
    [_equipField setEditable:NO];
    [self.insideView addSubview:_equipField];
    
    // Add a label for the equipment list
    UILabel *equipLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 487, 190, 32)];
    equipLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    equipLabel.textColor = [UIColor blackColor];
    equipLabel.text = @"Required Equipment:";
    [self.insideView addSubview:equipLabel];
    
    // Create a text view to hold the players list
    _players = [[UITextView alloc] initWithFrame:CGRectMake(110, 417, 190, 67)];
    [_players setBackgroundColor:[UIColor whiteColor]];
    [_players setEditable:NO];
    [_players setBackgroundColor:[UIColor whiteColor]];
    [self.insideView addSubview:_players];
    
    // Add a label for the players list
    UILabel *playersLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 421, 67, 21)];
    playersLabel.text = @"Players:";
    playersLabel.font = [UIFont fontWithName:@"DIN Alternate Bold" size:17];
    playersLabel.textColor = [UIColor blackColor];
    [self.insideView addSubview:playersLabel];

    // Set the location text
    _locField.text = self.info.location;
    
    //NSDateFormatter *day = [[NSDateFormatter alloc] init];
    //[day setDateFormat:@"MMM d, yyyy"];
    //NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //[timeFormat setDateFormat:@"hh:mm a"];
    
    // Create a local array of the players and a mutable string
    NSArray *ppl = [[NSArray alloc] initWithArray:self.info.players];
    NSMutableString *play = [[NSMutableString alloc] init];
    // Iterate through the array and add the players to the string
    for (int i = 0; i < ppl.count; i++) {
        [play appendString:[ppl objectAtIndex:i]];
        [play appendString:@"\n"];
    }
    // Set the players text view to be the compiled list of players
    _players.text = play;
    
    // Create a local array of the equipment and a mutable string
    NSArray *eq = [[NSArray alloc] initWithArray:self.info.equipment];
    NSMutableString *equip = [[NSMutableString alloc] init];
    // Iterate through the array and add the equipment to the string
    for (int i = 0; i < eq.count; i++) {
        [equip appendString:[eq objectAtIndex:i]];
        [equip appendString:@"\n"];
    }
    // Set the equipment text view to be the compiled equipment list
    _equipField.text = equip;
    
    // Create the Join button and set the title
    _button = [[UIButton alloc] initWithFrame:CGRectMake(115, 680, 90, 37)];
    [_button setTitle:@"Join" forState:UIControlStateNormal];
    // If the player is in the current players list, change the title to "Unjoin"
    for (int i = 0; i < self.info.players.count; i++) {
        if ([self.info.players[i] isEqualToString:appDelegate.user]) {
            [_button setTitle:@"Unjoin" forState:UIControlStateNormal];
        }
    }
    // Change the image of the button
    [_button setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // Set the action for the button
    [_button addTarget:self
                 action:@selector(buttonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.insideView addSubview:_button];

  
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

-(void)deleteEvent{
    // Create params and send to server for delete.
    // Issues on server. event_id is undefined. No idea why.
    // Need to dismiss this controller and getEvents. Done.
    NSLog(@"deleteEvent called");
    NSDictionary *params = @{@"event_id" : self.info.event_id, @"username" : appDelegate.user, @"isDeleted" : @"1"};
    [conn deleteEvent:params];
    [self performSelector:@selector(finishDelete) withObject:nil afterDelay:1];
}

-(void)finishDelete{
    NSLog(@"finishDelete");
    // After completion, dismiss current view controller
    if (appDelegate.success) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)buttonPressed:(id)sender{
    // Send update to server
    // This works on client side. Issue on server still.
    NSDictionary *params = @{@"event_id" : self.info.event_id, @"username" : appDelegate.user};
    [conn modEvent:params];
    
    [self performSelector:@selector(finishJoin) withObject:nil afterDelay:1];

}

-(void)finishJoin{
    // After completion, update the currently held players array and text view. Also change button title.
    if (appDelegate.success) {
        if ([_button.currentTitle isEqualToString:@"Join"]) {
            //[self.info.players insertObject:appDelegate.user atIndex:self.info.players.count];
            NSMutableArray *cpy = [[NSMutableArray alloc] initWithArray:self.info.players copyItems:YES];
            [cpy insertObject:appDelegate.user atIndex:cpy.count];
            self.info.players = cpy;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Event"
                                                            message:@"You have joined this event"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            NSArray *ppl = [[NSArray alloc] initWithArray:self.info.players];
            NSMutableString *play = [[NSMutableString alloc] init];
            for (int i = 0; i < ppl.count; i++) {
                [play appendString:[ppl objectAtIndex:i]];
                [play appendString:@"\n"];
            }
            _players.text = play;
            [self.players setNeedsDisplay]; // Not sure if needed yet
            [_button setTitle:@"Unjoin" forState:UIControlStateNormal];
        }
        else{
            NSMutableArray *cpy = [[NSMutableArray alloc] initWithArray:self.info.players copyItems:YES];
            for (int i = 0; i < cpy.count; i++) {
                if ([cpy[i] isEqualToString:appDelegate.user]) {
                    [cpy removeObjectAtIndex:i];
                    break;
                }
            }
            self.info.players = cpy;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Event"
                                                            message:@"You have removed yourself from his event"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            NSArray *ppl = [[NSArray alloc] initWithArray:self.info.players];
            NSMutableString *play = [[NSMutableString alloc] init];
            for (int i = 0; i < ppl.count; i++) {
                [play appendString:[ppl objectAtIndex:i]];
                [play appendString:@"\n"];
            }
            _players.text = play;
            [self.players setNeedsDisplay]; // Not sure if needed yet
            [_button setTitle:@"Join" forState:UIControlStateNormal];
        }
        
    }
}

@end
