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

#define BaseURLString @"http://bend.encs.vancouver.wsu.edu:12121/"

#define kEventID @"event_id"
#define kEventName @"eventName"
#define kSportKey @"eventSport"
#define kIsDeleted @"isDeleted"
#define kEventDate @"eventDate"
#define kTimeKey @"time_stamp"
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
    self.finished = NO;
    return self;
}

-(void)loginUser:(NSDictionary*)params{
    appDelegate.success = NO;
    NSLog(@"start of login");
    [manager POST:@"login"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              NSLog(@"success, received:%@", responseObject);
              if ([[responseObject objectForKey:@"session_token"] isEqual:0]){ // Error on this line!!!!!
                  NSLog(@"log out");
                  UIAlertView *logout = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                                   message:@"You have successfully logged out"
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                  [logout show];
                  appDelegate.user = nil;
                  appDelegate.password = nil;
                  appDelegate.email = nil;
                  appDelegate.sessionToken = 0;
              }
              else{
                  //appDelegate.loggedIn = YES;
                  appDelegate.user = [responseObject objectForKey:@"username"];
                  appDelegate.password = [params objectForKey:@"password"];
                  appDelegate.email = [params objectForKey:@"email"];
                  appDelegate.sessionToken = [responseObject objectForKey:@"session_token"];
              }
              appDelegate.success = YES;
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              NSLog(@"login fail: %d", statuscode);
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
    //self.finished = YES;
}

-(void)registerUser:(NSDictionary*)params{
    appDelegate.success = NO;
    self.finished = NO;
    [manager POST:@"register"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              appDelegate.success = YES;
              NSLog(@"tok:%@, success:%d", appDelegate.sessionToken, appDelegate.success);              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"in failure");
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              const int statuscode = response.statusCode;
              NSLog(@"Code: %d", statuscode);
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
    self.finished = YES;
}

-(void)addEvent:(NSDictionary*)params{
    appDelegate.success = NO;
    NSLog(@"adding event");
    [manager POST:@"addEvent"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"in success");
              // Enter success stuff here
              NSLog(@"responseObject:%@", responseObject);
              NSDictionary *something = @{@"time_stamp" : [responseObject objectForKey:@"time_stamp"]};
              [self getEvents:something]; // Hopefully this will work
              NSLog(@"getting events");
              appDelegate.success = YES;
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
    appDelegate.success = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    [manager GET:@"events"
      parameters:params
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject objectForKey:@"events"] != nil) {
                 NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"events"];
                 
                 for (int i = 0; i < arrayOfDicts.count; i++) {
                     if ([[arrayOfDicts[i] objectForKey:kIsDeleted] intValue] == 0) {
                         Event *event = [[Event alloc] init];
                         event.event_id = [arrayOfDicts[i] objectForKey:kEventID];
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
                             NSNumber *spot = [arrayOfDicts[i] objectForKey:kEventID];
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
             appDelegate.success = YES;
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             NSLog(@"in failure, code:%d", statuscode);
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
    appDelegate.success = NO;
    [manager POST:@"addEvent"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              NSDictionary *something = @{@"time_stamp" : [responseObject objectForKey:kTimeKey]};
              [self getEvents:something]; // Hopefully this will work
              appDelegate.success = YES;
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
    appDelegate.success = NO;
    [manager POST:@"deleteEvent"
       parameters:params
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              NSDictionary *something = @{@"time_stamp" : [responseObject objectForKey:kTimeKey]};
              [self getEvents:something]; // Hopefully this will work
              appDelegate.success = YES;
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
