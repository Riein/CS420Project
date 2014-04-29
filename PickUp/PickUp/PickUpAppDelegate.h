//
//  PickUpAppDelegate.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 3/6/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickUpAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *sessionToken;
@property (strong, nonatomic) NSString *password;
@property BOOL success;

@end
