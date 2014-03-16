//
//  MyEventsViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "MyEventsViewController.h"
#import "EventInfoViewController.h"

@interface MyEventsViewController ()

@end

@implementation MyEventsViewController{
    NSDictionary *_localList;
    NSMutableArray *_localKeys;
    NSString *_keyToPass;
    NSDictionary *_dictToPass;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_localList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PickUpGames" ofType:@"plist"];
        _localList = [[NSDictionary alloc] initWithContentsOfFile:path];
        _localKeys = [[[_localList allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_localKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_localKeys objectAtIndex:indexPath.row];
    NSDictionary *detail = [[NSDictionary alloc] init];
    detail = [_localList objectForKey:cell.textLabel.text];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"MMMM d, yyyy : hh:mm"];
    cell.detailTextLabel.text = [dateForm stringFromDate:[detail objectForKey:@"Date"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    _keyToPass = [_localKeys objectAtIndex:indexPath.row];
    _dictToPass = [_localList objectForKey:_keyToPass];
    
    EventInfoViewController *detailViewController = [[EventInfoViewController alloc] init];
    detailViewController.info = _dictToPass;
    detailViewController.title = _keyToPass;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
