//
//  ProfessionalViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/8/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "ProfessionalViewController.h"
#import "WebViewController.h"

@interface ProfessionalViewController ()

@end

@implementation ProfessionalViewController{
    NSDictionary *_bball;
    NSMutableArray *_bballKeys;
    NSDictionary *_basket;
    NSMutableArray *_basketKeys;
    NSDictionary *_soccer;
    NSMutableArray *_soccerKeys;
    NSDictionary *_foot;
    NSMutableArray *_footKeys;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_bball == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mlb" ofType:@"plist"];
        _bball = [[NSDictionary alloc] initWithContentsOfFile:path];
        _bballKeys = [[[_bball allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
    if (_basket == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"nba" ofType:@"plist"];
        _basket = [[NSDictionary alloc] initWithContentsOfFile:path];
        _basketKeys = [[[_basket allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
    if (_soccer == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mls" ofType:@"plist"];
        _soccer = [[NSDictionary alloc] initWithContentsOfFile:path];
        _soccerKeys = [[[_soccer allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
    if (_foot == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"nfl" ofType:@"plist"];
        _foot = [[NSDictionary alloc] initWithContentsOfFile:path];
        _footKeys = [[[_foot allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewController *detailViewController = [[WebViewController alloc] init];
    if ([_selection  isEqual: @"baseball"]) {
        NSString *key = [_bballKeys objectAtIndex:indexPath.row];
        detailViewController.urlString = [_bball objectForKey:key];
        detailViewController.title = key;
    }
    else if ([_selection  isEqual: @"basketball"]) {
        NSString *key = [_basketKeys objectAtIndex:indexPath.row];
        detailViewController.urlString = [_basket objectForKey:key];
        detailViewController.title = key;
    }
    else if ([_selection  isEqual: @"soccer"]) {
        NSString *key = [_soccerKeys objectAtIndex:indexPath.row];
        detailViewController.urlString = [_soccer objectForKey:key];
        detailViewController.title = key;
    }
    else if ([_selection  isEqual: @"football"]) {
        NSString *key = [_footKeys objectAtIndex:indexPath.row];
        detailViewController.urlString = [_foot objectForKey:key];
        detailViewController.title = key;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_selection  isEqual: @"football"]) {
        return [_foot count];
    }
    if ([_selection  isEqual: @"baseball"]) {
        return [_bball count];
    }
    if ([_selection  isEqual: @"basketball"]) {
        return [_basket count];
    }
    if ([_selection  isEqual: @"soccer"]) {
        return [_soccer count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if ([_selection  isEqual: @"football"]) {
        cell.textLabel.text = [_footKeys objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([_selection  isEqual: @"baseball"]) {
        cell.textLabel.text = [_bballKeys objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([_selection  isEqual: @"basketball"]) {
        cell.textLabel.text = [_basketKeys objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([_selection  isEqual: @"soccer"]) {
        cell.textLabel.text = [_soccerKeys objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

@end
