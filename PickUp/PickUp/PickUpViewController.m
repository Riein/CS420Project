//
//  PickUpViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "PickUpViewController.h"
#import "CreateEventViewController.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToMyEvents:(id)sender {
}

- (IBAction)createEvent:(id)sender {
    //[self prepareForSegue:segue sender:sender];
    [self performSegueWithIdentifier:@"createEvent" sender:sender];
}

- (IBAction)logout:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"createEvent"]){
        // Find out which button it is (I think)
        CreateEventViewController * destViewController = segue.destinationViewController;// Create the view controller instance
        [self presentViewController:destViewController animated:YES completion:nil];
    }
}
@end
