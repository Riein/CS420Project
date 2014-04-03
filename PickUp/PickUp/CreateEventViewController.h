//
//  CreateEventViewController.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,UIActionSheetDelegate, UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *sports;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)helpbutton:(id)sender;

- (IBAction)autofillbutton:(id)sender;


- (IBAction)createeventbutton:(id)sender;

- (IBAction)dateFieldClicked:(UIButton *)sender;
- (IBAction)timeFieldClicked:(UIButton *)sender;
- (IBAction)clearEquipment:(UIButton *)sender;
- (IBAction)autoFill:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UIButton *removeClicked;
@property (strong, nonatomic) IBOutlet UITextField *reqEquip;
@property (strong, nonatomic) UIDatePicker *picker;
@property (strong, nonatomic) UIView *customView;
@property (weak, nonatomic) IBOutlet UITextField *eventField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *playerField;

@end


