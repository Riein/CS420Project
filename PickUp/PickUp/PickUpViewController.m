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
        
        // Locking current thread until getEvents is complete
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [queue addOperation:[[NSInvocationOperation alloc] initWithTarget:conn selector:@selector(getEvents:) object:params]];
        
        [queue waitUntilAllOperationsAreFinished];
        
    }
    else{
        NSDate *checkDate = [NSDate distantPast];
        NSDictionary *params = @{@"time_stamp" : checkDate};
        
        // Locking current thread until getEvents is complete
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [queue addOperation:[[NSInvocationOperation alloc] initWithTarget:conn selector:@selector(getEvents:) object:params]];
        
        [queue waitUntilAllOperationsAreFinished];

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
    NSDictionary *params = @{@"username" : appDelegate.user, @"password" : appDelegate.password, @"session_token" : appDelegate.sessionToken};
    
    // Locking current thread until login is complete
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:[[NSInvocationOperation alloc] initWithTarget:conn selector:@selector(loginUser:) object:params]];
    
    [queue waitUntilAllOperationsAreFinished];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
