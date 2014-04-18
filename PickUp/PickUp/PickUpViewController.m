//
//  PickUpViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "PickUpViewController.h"
#import "CreateEventViewController.h"
#import "MyEventsViewController.h"
#import "Connection.h"
#import "PickUpAppDelegate.h"
#import "Event.h"

@interface PickUpViewController (){
    PickUpAppDelegate *appDelegate;
    Connection *conn;
}

@end

@implementation PickUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
    conn = [[Connection alloc] init];
    if (appDelegate.events.count > 0) {
        Event *latest = [appDelegate.events objectAtIndex:0];
        NSDate *checkDate = latest.timeStamp;
        NSDictionary *params = @{@"time_stamp" : checkDate};
        
        [conn getEvents:params];
        
    }
    else{
        NSDate *checkDate = [NSDate distantPast];
        NSDictionary *params = @{@"time_stamp" : checkDate};
        [conn getEvents:params];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToMyEvents:(id)sender {
}

- (IBAction)createEvent:(id)sender {
}

- (IBAction)logout:(id)sender {
    // Add actions to log user out of server
    NSLog(@"logout hit");
    NSLog(@"email: %@, pass: %@, sess: %@", appDelegate.email, appDelegate.password, appDelegate.sessionToken);
    NSDictionary *params = @{@"email" : appDelegate.email, @"password" : appDelegate.password, @"session_token" : appDelegate.sessionToken};
    NSLog(@"params:%@", params);
    [conn loginUser:params];
    [self performSelector:@selector(finishLogout) withObject:nil afterDelay:1];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)finishLogout{
    if (appDelegate.success) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
