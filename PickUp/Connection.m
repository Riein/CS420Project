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


@implementation Connection

-(id)init{
    if(self == nil){
        self = [super init];
    }
    return self;
}

-(ConnectionResponse*)loginWithUsername:(NSString*)username Password:(NSString*)password{
    ConnectionResponse* result = [[ConnectionResponse alloc] init];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    PickUpAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *parameters = @{@"username": username, @"password": password, @"session_token": delegate.sessionToken};
    [manager POST:@"login.cgi"
      parameters:parameters
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             NSString* sessionKey = [responseObject objectForKey:@"session_token"];
             result.success = YES;
             result.response = sessionKey;
             result.statusCode = 0;
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             int statuscode = response.statusCode;
             result.success = NO;
             result.statusCode = statuscode;
         }];
    
    manager = nil;
    
    return result;
}
-(ConnectionResponse*)registerWithUsername:(NSString*)username Password:(NSString*)password EMail:(NSString*)email{
    ConnectionResponse* result = [[ConnectionResponse alloc] init];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    PickUpAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *parameters = @{@"username": username, @"password": password, @"email": email};
    [manager POST:@"register.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              NSString* sessionKey = [responseObject objectForKey:@"session_token"];
              result.success = YES;
              result.response = sessionKey;
              result.statusCode = 0;
              delegate.sessionToken = sessionKey;
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              int statuscode = response.statusCode;
              result.success = NO;
              result.statusCode = statuscode;
          }];
    
    
    return result;
}

-(ConnectionResponse*)addEventWithEventID:(NSInteger)event_id Sport:(NSString*)sport Name:(NSString*)name Date:(NSDate*)date TimeStamp:(NSDate*)time Host:(NSString*)host Location:(NSString*)location Latitude:(NSNumber*)latitude Longitude:(NSNumber*)longitude Players:(NSMutableArray*)players Equipment:(NSMutableArray*)equipment{
    ConnectionResponse* result = [[ConnectionResponse alloc] init];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* eid = [NSString stringWithFormat: @"%d", (int)event_id];
    NSDictionary *parameters = @{@"event_id": eid, @"eventSport": sport, @"eventName": name, @"eventDate": [dateFormatter stringFromDate:date], @"timeStamp": [dateFormatter stringFromDate:time], @"host": host, @"location": location, @"latitude": [latitude stringValue], @"longitude": [longitude stringValue], @"players": [players componentsJoinedByString:@", "], @"equipment": [equipment componentsJoinedByString:@", "]};
    [manager POST:@"addEvent.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              
              result.success = YES;
              
              result.statusCode = 0;
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              int statuscode = response.statusCode;
              result.success = NO;
              result.statusCode = statuscode;
          }];
    
    
    
    
    return result;
}

-(ConnectionResponse*)getEventsAfter:(NSDate*)time{
    ConnectionResponse* result = [[ConnectionResponse alloc] init];
    PickUpAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDictionary *parameters = @{@"timeStamp": [dateFormatter stringFromDate:time]};
    [manager POST:@"event.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"events"];
              result.success = YES;
              
              result.statusCode = 0;
              
              for (NSDictionary *x in arrayOfDicts) {
               
                  NSInteger i = [[x objectForKey:@"event_id"] integerValue];
                  NSString *eventSport = [x objectForKey:@"eventSport"];
                  NSString *eventName = [x objectForKey:@"eventName"];
                  NSString* d = [x objectForKey:@"eventDate"];
                  NSDate* eventDate = [dateFormatter dateFromString:d];
                  NSString* t = [x objectForKey:@"timeStamp"];
                  NSDate* timeStamp = [dateFormatter dateFromString:t];
                  NSString *host = [x objectForKey:@"host"];
                  NSString *location = [x objectForKey:@"location"];
                  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                  NSString *l = [x objectForKey:@"latitude"];
                  NSNumber *latitude = [numberFormatter numberFromString:l];
                  l = [x objectForKey:@"longitude"];
                  NSNumber *longitude = [numberFormatter numberFromString:l];
                  NSString *p = [x objectForKey:@"players"];
                  NSMutableArray *players = [[p componentsSeparatedByString:@", "] mutableCopy];
                  NSString *e = [x objectForKey:@"equipment"];
                  NSMutableArray *equipment = [[e componentsSeparatedByString:@", "] mutableCopy];
                  
                  Event *event = [[Event alloc] init];
                  event.event_id = i;
                  event.eventName = eventName;
                  event.eventSport = eventSport;
                  event.eventDate = eventDate;
                  event.timeStamp = timeStamp;
                  event.host = host;
                  event.location = location;
                  event.latitude = latitude;
                  event.longitude = longitude;
                  event.players = players;
                  event.equipment = equipment;
                  
                  [delegate.events insertObject:event atIndex:0];
              }
              
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              int statuscode = response.statusCode;
              result.success = NO;
              result.statusCode = statuscode;
          }];
    
    
    
    
    return result;
}

-(ConnectionResponse*)modEventWithEventID:(NSInteger)event_id Username:(NSString*)username IsDeleted:(BOOL)isDeleted{
    ConnectionResponse* result = [[ConnectionResponse alloc] init];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* eid = [NSString stringWithFormat: @"%d", (int)event_id];
    NSString* del;
    if(isDeleted){
        del = @"1";
    }
    else{
        del = @"0";
    }
    NSDictionary *parameters = @{@"event_id": eid, @"username": username, @"isDeleted": del};
    [manager POST:@"modEvent.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              
              result.success = YES;
              
              result.statusCode = 0;
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
              int statuscode = response.statusCode;
              result.success = NO;
              result.statusCode = statuscode;
          }];
    
    
    
    
    return result;
}


@end
