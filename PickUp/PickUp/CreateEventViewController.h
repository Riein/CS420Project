//
//  CreateEventViewController.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSArray *sports;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)dateFieldClicked:(UIButton *)sender;
- (IBAction)timeFieldClicked:(UIButton *)sender;
- (IBAction)clearEquipment:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *reqEquip;
@property (strong, nonatomic) UIDatePicker *picker;
@property (strong, nonatomic) UIView *customView;
@end
