//
//  PickUpFirstViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "PickUpFirstViewController.h"
#import "SearchResultsViewController.h"
#import "PickUpAppDelegate.h"
#import "Event.h"

@interface PickUpFirstViewController ()

@end

@implementation PickUpFirstViewController{
    //UIPopoverController *popoverController;
    NSDate *dateToSet;
    PickUpAppDelegate *appDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _sports = @[@"All",@"Soccer", @"Baseball", @"Basketball", @"Disc Golf", @"Golf", @"Jousting"];
    appDelegate = [[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [textField resignFirstResponder];
    return YES;
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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 220, 80, 30)];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(setDateForButton:)forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 220, 80, 30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelDateForButton:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];
    
    [_customView addSubview:button];
    [_customView addSubview:cancelButton];
    
    [self.view addSubview:_customView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [_customView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
}

-(void)setDateForButton:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, yyyy"];
    NSString *newDate = [formatter stringFromDate:self.picker.date];
    [self.dateBut setTitle:newDate forState:UIControlStateNormal];
    [_customView removeFromSuperview];
}

-(void)cancelDateForButton:(id)sender{
    [self.dateBut setTitle:@"Select a Date" forState:UIControlStateNormal];
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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 220, 80, 30)];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    //[button setBackgroundColor:[UIColor lightGrayColor]];
    [button addTarget:self action:@selector(setTimeForButton:)forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 220, 80, 30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelTimeForButton:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"mybutton.png"] forState:UIControlStateNormal];
    
    [_customView addSubview:button];
    [_customView addSubview:cancelButton];
    
    [self.view addSubview:_customView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [_customView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
}


-(void)setTimeForButton:(id)sender{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *newDate = [formatter stringFromDate:self.picker.date];
    [self.timeBut setTitle:newDate forState:UIControlStateNormal];
    [_customView removeFromSuperview];
}

-(void)cancelTimeForButton:(id)sender{
    [self.timeBut setTitle:@"Select a Time" forState:UIControlStateNormal];
    [_customView removeFromSuperview];
}

- (IBAction)helpbutton:(id)sender {
    UIActionSheet *helpSheet =[[UIActionSheet alloc] initWithTitle:@"Frequently Asked Questions \n\n QUESTION: Can I search based on one thing? \n\n ANSWER: Yes. But the more information you give the application the better the app works.\n\n QUESTION: What if I do not see the sport I am looking for?\n\n  ANSWER: If you do not see your sport in the roll-a-dex then someone has not created an event for that sport.\n\n QUESTION: If somebody wrote a biography of you, what would it be titled?\n\n ANSWER: Scorned... Hopeful\n\n" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [helpSheet showInView:self.view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SearchResultsViewController *destView = segue.destinationViewController;
    destView.events = [self eventsSearched];
}

-(NSMutableArray*)eventsSearched{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:appDelegate.events copyItems:YES];
    NSLog(@"# of items:%d", temp.count);
    int remove[temp.count];
    for (int i = 0; i < temp.count; i++) {
        remove[i] = 0;
    }
    for (Event* e in appDelegate.events) {
        NSLog(@"Event Sport = %s", [e.eventSport cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
    
    // Need to remove events that don't match constraints from temp
    if ([_sports[[self.sportPicker selectedRowInComponent:0]] isEqualToString:@"All"]
            && [self.location.text  isEqual: @""] && [self.eventName.text  isEqual: @""] &&
        [self.dateBut.currentTitle isEqualToString:@"Select a Date"] && [self.timeBut.currentTitle isEqualToString:@"Select a Time"]) {
        return temp;
    }
    else{
        if (![_sports[[self.sportPicker selectedRowInComponent:0]] isEqualToString:@"All"]){
            NSLog(@"not all sports");
            for (int i = 0; i < temp.count; i++) {
                Event *event = [temp objectAtIndex:i];
                NSLog(@"Event %d Sport = %s", i, [event.eventSport cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
                if ([_sports[[self.sportPicker selectedRowInComponent:0]] isEqualToString:event.eventSport]) {
                    NSLog(@"is %@", _sports[[self.sportPicker selectedRowInComponent:0]]);
                    remove[i] = 0;
                }
                else{
                    NSLog(@"not %@", _sports[[self.sportPicker selectedRowInComponent:0]]);
                    remove[i] = 1;
                }
            }
        }
        for (int i = 0; i < temp.count; i++) {
            Event *event = [temp objectAtIndex:i];
            if (![self.eventName.text isEqualToString:event.eventName] && ![self.eventName.text isEqualToString:@""]) {
                NSLog(@"event name differs");
                remove[i] = 1;
            }
            if (![self.location.text isEqualToString:event.location] && ![self.location.text isEqualToString:@""]) {
                NSLog(@"location differs");
                remove[i] = 1;
            }
            
            NSArray *dateAndTime = [event.eventDate componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *date = [NSString stringWithFormat:@"%@ %@ %@", [dateAndTime objectAtIndex:0], [dateAndTime objectAtIndex:1], [dateAndTime objectAtIndex:2]];
            NSString *time= [NSString stringWithFormat:@"%@ %@", [dateAndTime objectAtIndex:3], [dateAndTime objectAtIndex:4]];
            NSLog(@"event.eventDate: %@", event.eventDate); // Good
            NSLog(@"butTitle: %@", self.dateBut.currentTitle);
            NSLog(@"date before check: %@", date);
            if (![self.dateBut.currentTitle isEqualToString:date] && ![self.dateBut.currentTitle isEqualToString:@"Select a Date"]) {
                NSLog(@"date differs");
                //NSLog(@"%@ : %@", self.dateBut.currentTitle, date);
                remove[i] = 1;
            }
            NSLog(@"butTitle: %@", self.timeBut.currentTitle);
            NSLog(@"time: %@", time);
            if (![self.timeBut.currentTitle isEqualToString:time] && ![self.timeBut.currentTitle isEqualToString:@"Select a Time"]) {
                NSLog(@"time differs");
                //NSLog(@"%@ : %@", self.timeBut.currentTitle, time);
                remove[i] = 1;
            }
        }
    }
    NSMutableArray *events = [[NSMutableArray alloc] init];
    for (int i = 0; i < temp.count; i++) {
        if (remove[i] == 0) {
            [events addObject:[temp objectAtIndex:i]];
        }
    }

    return events;
}

@end
