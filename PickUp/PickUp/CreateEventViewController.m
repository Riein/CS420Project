//
//  CreateEventViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController (){
    NSMutableString *equip;
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
    _sports = @[@"Soccer", @"Baseball", @"Basketball", @"Frisbee", @"Golf"];
    self.scrollView.ContentSize = CGSizeMake(320, 517);
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.delaysContentTouches = NO;
    equip = [[NSMutableString alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}

#define kOFFSET_FOR_KEYBOARD 90.0

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
        [equip setString:self.textView.text];
        [equip appendString:@"\n"];
        [equip appendString:textField.text];
        self.textView.text = equip;
    }
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

@end
