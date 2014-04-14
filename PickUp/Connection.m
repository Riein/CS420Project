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
#define BaseURLString @"http://bend.encs.vancouver.wsu.edu/~mpessa/"


@implementation Connection

-(id)init{
    if(self == nil){
        self = [super init];
    }
    return self;
}

-(int)loginWithUsername:(NSString*)username Password:(NSString*)password{
    int result = 0;
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"username": username, @"password": password};
    [manager POST:@"login.cgi"
      parameters:parameters
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"tweets"];
             //
             // Add new (sorted) tweets to head of appDelegate.tweets array.
             // If implementing delete, some older tweets may be purged.
             // Invoke [self.tableView reloadData] if any changes.
             //
             [self.refreshControl endRefreshing];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             result = 
         }];
    
    
    
    
    return result;
}
-(int)registerWithUsername:(NSString*)username Password:(NSString*)password EMail:(NSString*)email;
-(int)addEventWithEventID:(NSInteger)event_id Sport:(NSString*)sport Name:(NSString*)name Date:(NSDate*)date TimeStamp:(NSDate*)time Host:(NSString*)host Location:(NSString*)location Latitude:(NSNumber*)latitude Longitude:(NSNumber*)longitude Players:(NSMutableArray*)players Equipment:(NSMutableArray*)equipment;
-(int)findEventWithSport:(NSString*)sport Name:(NSString*)name Location:(NSString*)location Date:(NSDate*)date;
-(int)modEventWithEventID:(NSInteger)event_id Username:(NSString*)username IsDeleted:(BOOL)isDeleted;

@end
