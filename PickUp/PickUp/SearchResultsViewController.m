//
//  SearchResultsViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/8/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "EventInfoViewController.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController{
    NSDictionary *_localList;
    NSMutableArray *_localKeys;
    NSString *_keyToPass;
    NSDictionary *_dictToPass;
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
    if (_localList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PickUpGames" ofType:@"plist"];
        _localList = [[NSDictionary alloc] initWithContentsOfFile:path];
        _localKeys = [[[_localList allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
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
    return [_localKeys count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_localKeys objectAtIndex:indexPath.row];
    NSDictionary *detail = [[NSDictionary alloc] init];
    detail = [_localList objectForKey:cell.textLabel.text];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"MMMM d, yyyy : hh:mm a"];
    cell.detailTextLabel.text = [dateForm stringFromDate:[detail objectForKey:@"Date"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _keyToPass = [_localKeys objectAtIndex:indexPath.row];
    _dictToPass = [_localList objectForKey:_keyToPass];
    
    EventInfoViewController *detailViewController = [[EventInfoViewController alloc] init];
    detailViewController.info = _dictToPass;
    detailViewController.title = _keyToPass;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
