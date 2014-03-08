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

@interface PickUpViewController ()

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
