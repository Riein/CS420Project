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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dict:(NSDictionary *)dict title:(NSString *)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization... Pass in the title and dictionary from the cell.
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = title;
        [self.view addSubview:label];
        _info = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButton:(id)sender {
    if (_joined) {
        self.joined = NO;
        [sender setTitle:@"Join"];
        // Update the DB to show no longer joined
    }
    else{
        self.joined = YES;
        [sender setTitle:@"Unjoin"];
        // Update the DB to show attending
    }
}

@end
