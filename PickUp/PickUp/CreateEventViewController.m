//
//  CreateEventViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "CreateEventViewController.h"
#import "Event.h"
#import "PickUpAppDelegate.h"
#import "Connection.h"
#import <CoreLocation/CoreLocation.h>

@interface CreateEventViewController (){
    NSMutableString *equip;
    BOOL first, selectedRow, incomplete;
    NSMutableArray *equipList;
    NSMutableArray *soccerList, *footballList, *baseballList, *frisbeeList, *golfList;
    NSInteger rowIndex;
    int errs[7];
    PickUpAppDelegate *appDelegate;
    Connection *conn;
}

@end

@implementation CreateEventViewController

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
    _sports = @[@"Soccer", @"Baseball", @"Football", @"Disc Golf", @"Golf"];
    self.scrollView.ContentSize = CGSizeMake(320, 580);
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.delaysContentTouches = NO;
    equip = [[NSMutableString alloc] init];
    first = YES;
    selectedRow = NO;
    incomplete = YES;
    equipList = [[NSMutableArray alloc] initWithObjects:@"None", nil];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Creating tableView programatically to try.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 360, 290, 130)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.scrollView addSubview:self.tableView];
    soccerList = [[NSMutableArray alloc] initWithObjects:@"Cleats", @"Light colored shirt", @"Dark colored shirt", @"Shinguards", @"Soccer ball" , nil];
    footballList = [[NSMutableArray alloc] initWithObjects:@"Cleats", @"Light colored shirt", @"Dark colored shirt", @"Shoulder pads", nil];
    baseballList = [[NSMutableArray alloc] initWithObjects:@"Cleats", @"Helmet", @"Bat", @"Glove", nil];
    frisbeeList = [[NSMutableArray alloc] initWithObjects:@"Discs", nil];
    golfList = [[NSMutableArray alloc] initWithObjects:@"Clubs", @"69 Golf balls", @"42 Tees", nil];
    rowIndex = 0;
    for (int i = 0; i < 6; i++) {
        errs[i] = 0;
    }
    conn = [[Connection alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}

#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.reqEquip]) {
        if (first) {
            [equipList removeAllObjects];
            first = NO;
        }
        NSString *newEquip = textField.text;
        [equipList addObject:newEquip];
        [self.tableView reloadData];
    }
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)clearEquipment:(UIButton *)sender {
    if (selectedRow && ![[equipList objectAtIndex:0] isEqualToString:@"None"]) {
        [equipList removeObjectAtIndex:rowIndex];
        [self.removeClicked setTitle:@"Remove All" forState:UIControlStateNormal];
        selectedRow = NO;
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        [self.tableView reloadData];
    }
    else {
        NSMutableArray *resetList = [[NSMutableArray alloc] initWithObjects:@"None", nil];
        equipList = resetList;
        first = YES;
        [self.tableView reloadData];
    }
//    self.textView.text = @"Equipment List:";
//    first = YES;
}

- (IBAction)autoFill:(id)sender {
    NSInteger sportIndex = [self.sportPicker selectedRowInComponent:0];
    NSString *sport = [_sports objectAtIndex:sportIndex];
    NSMutableArray *temp;
    if ([sport isEqualToString:@"Soccer"]) {
        temp = [[NSMutableArray alloc] initWithArray:soccerList copyItems:YES];
    }
    if ([sport isEqualToString:@"Football"]) {
        temp = [[NSMutableArray alloc] initWithArray:footballList copyItems:YES];
    }
    if ([sport isEqualToString:@"Baseball"]) {
        temp = [[NSMutableArray alloc] initWithArray:baseballList copyItems:YES];
    }
    if ([sport isEqualToString:@"Disc Golf"]) {
        temp = [[NSMutableArray alloc] initWithArray:frisbeeList copyItems:YES];
    }
    if ([sport isEqualToString:@"Golf"]) {
        temp = [[NSMutableArray alloc] initWithArray:golfList copyItems:YES];
    }
    equipList = temp;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}


#pragma mark - PickerView DataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _sports.count;
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:_sports[row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    return attString;
}

#pragma mark - PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    // Do nothing in here right now
}

#pragma mark - DatePickerPopover

- (IBAction)helpbutton:(id)sender {
    UIActionSheet *helpSheet =[[UIActionSheet alloc] initWithTitle:@"Frequently Asked Questions \n\n QUESTION: How do I remove just one item from the equipment list? \n\n ANSWER: To remove one item, select it and click the Remove button.\n\n QUESTION: Do I have to fill in all of the fields to create an event?\n\n  ANSWER: Yes. All of the fields are important information for anyone to know when joining a pickup game.\n\n QUESTION: How much wood WOULD a woodchuck chuck, if a woodchuck could chuck wood?\n\n ANSWER: I really have no idea!\n\n" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    helpSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [helpSheet showInView:self.view];
}

- (IBAction)autofillbutton:(id)sender {
}

- (IBAction)createeventbutton:(id)sender {
    incomplete = NO;
    NSArray *errMess = [[NSArray alloc] initWithObjects:@"Event name is blank\n", @"Location is blank\n", @"Players needed is blank\n", @"Date needs to be selected\n", @"Time needs to be selected\n", @"The date must be in the future", @"Number of players must be an integer", nil];
    if ([self.eventField.text isEqualToString:@""]) {
        incomplete = YES;
        errs[0] = 1;
    }
    if ([self.locationField.text isEqualToString:@""]) {
        incomplete = YES;
        errs[1] = 1;
    }
    if ([self.playerField.text isEqualToString:@""]) {
        incomplete = YES;
        errs[2] = 1;
    }
    NSCharacterSet *ints = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self.playerField.text rangeOfCharacterFromSet:ints].location != NSNotFound) {
        incomplete = YES;
        errs[6] = 1;
    }
    if ([self.dateButton.currentTitle isEqualToString:@"Select a Date"]) {
        incomplete = YES;
        errs[3] = 1;
    }
    if ([self.timeButton.currentTitle isEqualToString:@"Select a Time"]) {
        incomplete = YES;
        errs[4] = 1;
    }
    // Should error check for time now, not just date. Having issues with check. Only working on date still.
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM d, yyyy"];
    //NSCalendar *gCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *gCal = [NSCalendar currentCalendar];
    [gCal setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [format dateFromString:self.dateButton.currentTitle];
    [format setDateFormat:@"HH:mm a"];
    NSDate *time = [format dateFromString:self.timeButton.currentTitle];
    NSLog(@"%@", time);
    NSDateComponents *dateComp = [gCal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    NSDateComponents *timeComp = [gCal components:NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:time];
    NSDateComponents *combine = [[NSDateComponents alloc] init];
    NSLog(@"parts-hr:%d,mi:%d", timeComp.hour, timeComp.minute);
    [combine setYear:dateComp.year];
    [combine setMonth:dateComp.month];
    [combine setDay:dateComp.day];
    [combine setHour:timeComp.hour];
    [combine setMinute:timeComp.minute];
    NSDate *checkDate = [gCal dateFromComponents:combine];
    NSLog(@"checkDate: %@, now: %@, diff: %f", checkDate, [NSDate date], [checkDate timeIntervalSinceNow]);
    if ([checkDate timeIntervalSinceNow] <= 0) {
        incomplete = YES;
        errs[5] = 1;
    }
    
    if (!incomplete) {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Create Event"
                                                    message:@"Are you sure you would like to create this event?" delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Accept", nil];
        [check show];
    }
    else{
        NSMutableString *errorMess = [[NSMutableString alloc] init];
        for (int i = 0; i < 7; i++) {
            if (errs[i] == 1) {
                [errorMess appendString:errMess[i]];
            }
        }
        UIAlertView *nope = [[UIAlertView alloc] initWithTitle:@"Incomplete Form"
                                                       message:errorMess
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [nope show];
    }
    for (int i = 0; i < 7; i++) {
        errs[i] = 0;
    }

    incomplete = NO;
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
        //NSLog(@"Index 0");
    }else{
        //reset clicked
        [self addEvent];
    }
}

-(void)addEvent{
    Event *newEvent = [[Event alloc] init];
    newEvent.eventName = self.eventField.text;
    newEvent.eventSport = _sports[[self.sportPicker selectedRowInComponent:0]];
    newEvent.location = self.locationField.text;
    //Location lat-long magic happens here
    CLLocationCoordinate2D newCoord = [self geoCodeUsingAddress:newEvent.location];
    newEvent.latitude = [NSNumber numberWithDouble:newCoord.latitude];
    newEvent.longitude = [NSNumber numberWithDouble:newCoord.longitude];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM d, yyyy"];
    NSCalendar *gCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gCal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PDT"]];
    NSDate *date = [format dateFromString:self.dateButton.currentTitle];
    [format setDateFormat:@"HH:mm a"];
    NSDate *time = [format dateFromString:self.timeButton.currentTitle];
    NSDateComponents *dateComp = [gCal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    NSDateComponents *timeComp = [gCal components:NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:time];
    NSDateComponents *combine = [[NSDateComponents alloc] init];
    [combine setYear:dateComp.year];
    [combine setMonth:dateComp.month];
    [combine setDay:dateComp.day];
    [combine setHour:timeComp.hour];
    [combine setMinute:timeComp.minute];
    newEvent.eventDate = [gCal dateFromComponents:combine];
    newEvent.players = [@[appDelegate.user] copy];
    newEvent.host = appDelegate.user;
    newEvent.equipment = equipList;
    
    NSDictionary *params = @{@"host" : newEvent.host, @"eventName" : newEvent.eventName, @"eventDate" : [format stringFromDate:newEvent.eventDate], @"location" : newEvent.location, @"latitude" : newEvent.latitude, @"longitude" : newEvent.longitude, @"players" : newEvent.players, @"equipment" : newEvent.equipment};
    [conn addEvent:params];
    //[appDelegate.events insertObject:newEvent atIndex:0];
    
    UIActionSheet *helpSheet =[[UIActionSheet alloc] initWithTitle:@"YOUR EVENT HAS BEEN CREATED" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [helpSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Goes too far. Goes back to login page.
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dateFieldClicked:(UIButton*)sender{
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, sender.center.y - 150, 320, 264)];
    
    _customView.alpha = 0.0;
    _customView.layer.cornerRadius = 5;
    _customView.layer.borderWidth = 1.5f;
    _customView.layer.masksToBounds = YES;
    _customView.backgroundColor = [UIColor whiteColor];
    
    _picker = [[UIDatePicker alloc] init];
    _picker.frame = CGRectMake(0, 0, 320, 216);
    _picker.datePickerMode = UIDatePickerModeDate;
    [_customView addSubview:_picker];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 220, 80, 30)];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor lightGrayColor]];
    [button addTarget:self action:@selector(setDateForButton:)forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];

    [_customView addSubview:button];
    
    [self.view addSubview:_customView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [_customView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
}

-(void)setDateForButton:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, yyyy"];
    NSString *newDate = [formatter stringFromDate:self.picker.date];
    [self.dateButton setTitle:newDate forState:UIControlStateNormal];
    [_customView removeFromSuperview];
}

#pragma mark - Time Picker Popover

-(IBAction)timeFieldClicked:(UIButton*)sender{
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, sender.center.y - 203, 320, 264)];
    
    _customView.alpha = 0.0;
    _customView.layer.cornerRadius = 5;
    _customView.layer.borderWidth = 1.5f;
    _customView.layer.masksToBounds = YES;
    _customView.backgroundColor = [UIColor whiteColor];
    
    _picker = [[UIDatePicker alloc] init];
    _picker.frame = CGRectMake(0, 0, 320, 216);
    _picker.datePickerMode = UIDatePickerModeTime;
    [_customView addSubview:_picker];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 220, 80, 30)];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(setTimeForButton:)forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];

    [_customView addSubview:button];
    
    [self.view addSubview:_customView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [_customView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
}

-(void)setTimeForButton:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *newDate = [formatter stringFromDate:self.picker.date];
    [self.timeButton setTitle:newDate forState:UIControlStateNormal];
    [_customView removeFromSuperview];
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [equipList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"equipment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [equipList objectAtIndex:indexPath.row];
//    NSDictionary *detail = [[NSDictionary alloc] init];
//    detail = [_localList objectForKey:cell.textLabel.text];
//    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
//    [dateForm setDateFormat:@"MMMM d, yyyy : hh:mm a"];
//    cell.detailTextLabel.text = [dateForm stringFromDate:[detail objectForKey:@"Date"]];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = YES;
    [self.removeClicked setTitle:@"Remove" forState:UIControlStateNormal];
    rowIndex = indexPath.row;
    
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    
////    _keyToPass = [_localKeys objectAtIndex:indexPath.row];
////    _dictToPass = [_localList objectForKey:_keyToPass];
////    
////    EventInfoViewController *detailViewController = [[EventInfoViewController alloc] init];
////    detailViewController.info = _dictToPass;
////    detailViewController.title = _keyToPass;
////    
////    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
