//
//  SearchResultsViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/8/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "EventInfoViewController.h"
#import "Event.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController{
    NSString *_keyToPass;
    Event *_dictToPass;
}

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
    [self.navigationItem setHidesBackButton:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.events count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Event *temp = [[Event alloc] init];
    temp = [self.events objectAtIndex:indexPath.row];
    cell.textLabel.text = temp.eventName;
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"MMMM d, yyyy : HH:mm a"];
    [dateForm setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PDT"]];
    NSDateFormatter *tempFormat = [[NSDateFormatter alloc] init];
    [tempFormat setDateFormat:@"MMM d, yyyy, HH:mm:ss a"];
    [tempFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *tempDate = [tempFormat dateFromString:temp.eventDate];
    NSString *date = [dateForm stringFromDate:tempDate];
    NSLog(@"eventDate: %@", temp.eventDate);
    NSLog(@"tempDate: %@", tempDate);
    NSLog(@"date: %@", date);
    cell.detailTextLabel.text = date;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Event *temp = [[Event alloc] init];
    temp = [self.events objectAtIndex:indexPath.row];
    _keyToPass = temp.eventName;
    _dictToPass = temp;
    
    EventInfoViewController *detailViewController = [[EventInfoViewController alloc] init];
    detailViewController.info = _dictToPass;
    detailViewController.title = _keyToPass;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
