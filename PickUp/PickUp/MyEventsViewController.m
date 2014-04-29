//
//  MyEventsViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "MyEventsViewController.h"
#import "EventInfoViewController.h"
#import "PickUpAppDelegate.h"
#import "Event.h"

@interface MyEventsViewController ()

@end

@implementation MyEventsViewController{
    NSMutableArray *_myEvents;
    NSString *_keyToPass;
    Event *_dictToPass;
    PickUpAppDelegate *appDelegate;
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
    _myEvents = [[NSMutableArray alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [_myEvents removeAllObjects];
    for (Event *e in appDelegate.events) {
        for (NSString *player in e.players) {
            if ([appDelegate.user isEqualToString:player]) {
                [_myEvents addObject:e];
            }
        }
    }
    [self.tableView reloadData];
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
    return [_myEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Event *temp = [[Event alloc] init];
    temp = [_myEvents objectAtIndex:indexPath.row];
    cell.textLabel.text = temp.eventName;
    NSDictionary *detail = [[NSDictionary alloc] init];
    detail = [_myEvents objectAtIndex:indexPath.row];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"MMMM d, yyyy : hh:mm a"];
    [dateForm setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PDT"]];
    cell.detailTextLabel.text = temp.eventDate;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(IBAction)refreshControlValueChanged:(UIRefreshControl *) sender{
    [_myEvents removeAllObjects];
    for (Event *e in appDelegate.events) {
        for (NSString *player in e.players) {
            if ([appDelegate.user isEqualToString:player]) {
                [_myEvents addObject:e];
            }
        }
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Event *temp = [[Event alloc] init];
    temp = [_myEvents objectAtIndex:indexPath.row];
    _keyToPass = temp.eventName;
    _dictToPass = temp;
    
    EventInfoViewController *detailViewController = [[EventInfoViewController alloc] init];
    detailViewController.info = _dictToPass;
    detailViewController.title = _keyToPass;
    //NSLog(@"event_id passed:%@", _dictToPass.event_id); // Does not like event_id
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
