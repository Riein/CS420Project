//
//  Connection.m
//  PickUp
//
//  Created by Ethan G Schulze on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "Connection.h"
#import "AFNetworking.h"
#import "PickUpAppDelegate.h"
#import "Event.h"

#define BaseURLString @"http://bend.encs.vancouver.wsu.edu/~mpessa/"

#define kEventID @"event_id"
#define kEventName @"eventName"
#define kSportKey @"eventSport"
#define kIsDeleted @"isDeleted"
#define kEventDate @"date"
#define kTimeKey @"timeStamp"
#define kHostKey @"host"
#define kLocKey @"location"
#define kLatKey @"latitude"
#define kLongKey @"longitude"
#define kPlayersKey @"players"
#define kEquipmentKey @"equipment"

#define kUsername @"username"

@implementation Connection{
    PickUpAppDelegate *appDelegate;
    AFHTTPSessionManager *manager;
}

-(id)init{
    if(self == nil){
        self = [super init];
    }
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    appDelegate = [[UIApplication sharedApplication] delegate];
    return self;
}

-(void)loginUser:(NSDictionary*)params{
    [manager POST:@"login"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              if ([[responseObject objectForKey:@"session_token"] isEqualToString:@"0"]){
                  UIAlertView *logout = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                                   message:@"You have successfully logged out"
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                  [logout show];
                  appDelegate.user = nil;
                  appDelegate.password = nil;
                  appDelegate.sessionToken = 0;
              }
              else{
                  //appDelegate.loggedIn = YES;
                  appDelegate.user = [params objectForKey:kUsername];
                  appDelegate.password = [params objectForKey:@"password"];
                  appDelegate.sessionToken = [responseObject objectForKey:@"session_token"];
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              //
              // Display AlertView with appropriate error message.
              //
              if (statuscode == 500) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Something stranged happened....."
                                                                message:@"There was an issue logging in\nPlease try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 400) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                message:@"Username and password must be entered"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 404) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"User does not exist"
                                                                message:@"Please register before attempting to log in"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
}

-(void)registerUser:(NSDictionary*)params{
    [manager POST:@"register"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              if ([responseObject objectForKey:@"session_token"] != nil){
                  appDelegate.sessionToken = [responseObject objectForKey:@"session_token"];
                  UIAlertView *reg = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                message:@"You have successfully registered\nPlease log in to continue"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [reg show];
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"in failure");
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              //
              // Display AlertView with appropriate error message.
              //
              if (statuscode == 500) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Something stranged happened....."
                                                                message:@"There was an issue logging in\nPlease try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 400) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                message:@"Username and password must be entered"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 409) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"User already exists"
                                                                message:@"The username already exists\nPlease try a different username"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
    
}

-(void)addEvent:(NSDictionary*)params{
    [manager POST:@"addEvent"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              NSDictionary *something = @{@"time_stamp" : [responseObject objectForKey:kTimeKey]};
              [self getEvents:something]; // Hopefully this will work
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              //NSLog(@"in failure");
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              //
              // Display AlertView with appropriate error message.
              //
              if (statuscode == 500) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Something stranged happened....."
                                                                message:@"There was an issue logging in\nPlease try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 400) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                message:@"All fields must be entered"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
}

-(void)getEvents:(NSDictionary*)params{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    [manager GET:@"getEvents"
      parameters:params
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject objectForKey:@"events"] != nil) {
                 NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"events"];
                 
                 for (int i = 0; i < arrayOfDicts.count; i++) {
                     if ([[arrayOfDicts[i] objectForKey:kIsDeleted] intValue] == 0) {
                         Event *event = [[Event alloc] init];
                         event.event_id = [[arrayOfDicts[i] objectForKey:kEventID] intValue];
                         event.eventName = [arrayOfDicts[i] objectForKey:kEventName];
                         event.eventSport = [arrayOfDicts[i] objectForKey:kSportKey];
                         event.isDeleted = [[arrayOfDicts[i] objectForKey:kIsDeleted] intValue];
                         event.eventDate = [arrayOfDicts[i] objectForKey:kEventDate];
                         event.timeStamp = [arrayOfDicts[i] objectForKey:kTimeKey];
                         event.host = [arrayOfDicts[i] objectForKey:kHostKey];
                         event.location = [arrayOfDicts[i] objectForKey:kLocKey];
                         event.latitude = [arrayOfDicts[i] objectForKey:kLatKey];
                         event.longitude = [arrayOfDicts[i] objectForKey:kLongKey];
                         event.players = [arrayOfDicts[i] objectForKey:kPlayersKey];
                         event.equipment = [arrayOfDicts[i] objectForKey:kEquipmentKey];
                         [appDelegate.events insertObject:event atIndex:0];
                     }
                     else{
                         // If the tweet was deleted, go through the local tweet list and remove it
                         for (int j = 0; j < arrayOfDicts.count; j++) {
                             int spot = [[arrayOfDicts[i] objectForKey:kEventID] intValue];
                             for (int i = 0; i < appDelegate.events.count; i++) {
                                 Event *event = [appDelegate.events objectAtIndex:i];
                                 if (spot == event.event_id) {
                                     [appDelegate.events removeObjectAtIndex:i];
                                     break;
                                 }
                             }
                         }
                     }
                 }
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"in failure");
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             //
             // Display AlertView with appropriate error message.
             //
             if (statuscode == 500) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"You shouldn't be seeing this"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
}

-(void)modEvent:(NSDictionary*)params{
    [manager POST:@"addEvent"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              NSDictionary *something = @{@"time_stamp" : [responseObject objectForKey:kTimeKey]};
              [self getEvents:something]; // Hopefully this will work
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              //NSLog(@"in failure");
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              //
              // Display AlertView with appropriate error message.
              //
              if (statuscode == 500) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Something stranged happened....."
                                                                message:@"There was an issue logging in\nPlease try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 400) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                message:@"All fields must be entered"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
}

-(void)deleteEvent:(NSDictionary*)params{
    [manager POST:@"deleteEvent"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              NSDictionary *something = @{@"time_stamp" : [responseObject objectForKey:kTimeKey]};
              [self getEvents:something]; // Hopefully this will work
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              //NSLog(@"in failure");
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              //
              // Display AlertView with appropriate error message.
              //
              if (statuscode == 500) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Something stranged happened....."
                                                                message:@"There was an issue logging in\nPlease try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
}

@end
