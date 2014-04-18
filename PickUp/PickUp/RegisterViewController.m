//
//  RegisterViewController.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/7/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "RegisterViewController.h"
#import "Connection.h"
#import "PickUpAppDelegate.h"

@interface RegisterViewController (){
    Connection *conn;
    PickUpAppDelegate *appDelegate;
}

@end

@implementation RegisterViewController

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
//
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
- (IBAction)helpbutton:(id)sender {
    UIActionSheet *helpSheet =[[UIActionSheet alloc] initWithTitle:@"Frequently Asked Questions \n\n QUESTION: Why won't it accept my password? \n\n ANSWER: Your password must be AT LEAST 6 characters long for it to accept.\n\n QUESTION: Can you describe yourself in 3 words ?\n\n  ANSWER: Of course. I'm a computer application, so ruggedly handsome (some say quite beautiful), fast and able to leap tall buildings in a single bound. \n\n" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [helpSheet showInView:self.view];
    
    
    
}

- (IBAction)registerPressed:(UIButton *)sender {
    if ([self.email.text isEqualToString:@""] || [self.username.text isEqualToString:@""] || [self.pass.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                        message:@"All fields must be entered"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([self.username.text length] < 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Username Length"
                                                        message:@"Username must be at least 4 characters long."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
 
    }
    
    else if ([self.pass.text length] < 6){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password Length"
                                                        message:@"Password must be at least 6 characters long."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    else if (![self NSStringIsValidEmail:self.email.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email address"
                                                        message:@"Please enter a valid email address"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        NSString *email = self.email.text;
        NSString *name = self.username.text;
        NSString *pass = self.pass.text;
        NSDictionary *params = @{@"email" : email, @"username" : name, @"password" : pass};
                
        [conn registerUser:params];
        [self performSelector:@selector(finishRegister) withObject:nil afterDelay:1.5];
//        if (appDelegate.sessionToken != nil && appDelegate.success) {
//            NSLog(@"logging in after register");
//            NSDictionary *log = @{@"email" : email, @"password" : pass, @"session_token" : appDelegate.sessionToken};
//            [conn loginUser:log];
//            if (appDelegate.sessionToken != 0 && appDelegate.success) {
//                [self performSegueWithIdentifier:@"register" sender:self];
//            }
//        }
    }
}

-(void)finishRegister{
    if (appDelegate.sessionToken != nil && appDelegate.success) {
        NSString *email = self.email.text;
        NSString *pass = self.pass.text;
        NSDictionary *log = @{@"email" : email, @"password" : pass, @"session_token" : appDelegate.sessionToken};
        [conn loginUser:log];
        [self performSelector:@selector(loginAfterRegister) withObject:nil afterDelay:1.5];
    }
}

-(void)loginAfterRegister{
    if (appDelegate.sessionToken != 0 && appDelegate.success) {
        [self performSegueWithIdentifier:@"register" sender:self];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
