//
//  PickUpFirstViewController.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickUpFirstViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *sports;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
//@property (strong, nonatomic) UIPopoverController *popoverController;

- (IBAction)dateFieldClicked:(id)sender;
- (IBAction)timeFieldClicked:(id)sender;

- (IBAction)helpbutton:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *dateBut;
@property (weak, nonatomic) IBOutlet UIButton *timeBut;
@property (strong, nonatomic) UIDatePicker *picker;
@property (strong, nonatomic) UIView *customView;

@end
