//
//  LoginViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "LoginViewController.h"
#import "PickUpAppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Connection.h"


@interface LoginViewController (){
    Connection *conn;
    PickUpAppDelegate *appDelegate;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    conn = [[Connection alloc] init];
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

//-(void)textFieldDidBeginEditing:(UITextField *)sender
//{
//    if ([sender isEqual:self.pass])
//    {
//        //move the main view, so that the keyboard does not hide it.
//        if  (self.view.frame.origin.y >= 0)
//        {
//            [self setViewMovedUp:YES];
//        }
//    }
//}

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

- (IBAction)forgotpasswordbutton:(id)sender {
    UIActionSheet *helpSheet =[[UIActionSheet alloc] initWithTitle:@"Frequently Asked Questions \n\n QUESTION: How do reset my password? \n\n ANSWER: To reset your password, email: passwordreset@gmail.com.\n\n QUESTION: How do I retrieve my current password?\n\n  ANSWER: Not gunna do it. Nope! Can't make me. Sorry sucka!\n\n" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [helpSheet showInView:self.view];
}

- (IBAction)loginPressed:(UIButton *)sender {
    if ([self.email.text isEqualToString:@""] || [self.pass.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                        message:@"Email and password must be entered"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
       // NSString *email = self.email.text;
        //NSString *pass = self.pass.text;
        //NSDictionary *params = @{@"email" : email, @"password" : pass};
        //[conn loginUser:params];
        if (appDelegate.sessionToken != 0) {
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }
}
@end
