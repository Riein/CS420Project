//
//  RegisterViewController.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate>

- (IBAction)helpbutton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *pass;
@end
