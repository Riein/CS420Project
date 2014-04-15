//
//  PickUpSecondViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "PickUpSecondViewController.h"
#import "ProfessionalViewController.h"
#import "Connection.h"
#import "PickUpAppDelegate.h"
#import "Event.h"

@interface PickUpSecondViewController (){
    PickUpAppDelegate *appDelegate;
    Connection *conn;
}

@end

@implementation PickUpSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ProfessionalViewController *destViewController = segue.destinationViewController;
    destViewController.selection = segue.identifier;
}

@end
