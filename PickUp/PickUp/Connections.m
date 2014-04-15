//
//  Connections.m
//  PickUp
//
//  Created by Matthew Steven Pessa on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "Connections.h"
#import "PickUpAppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Event.h"

#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"

#define kEventID @"event_id"
#define kEventName @"eventName"
#define kSportKey @"eventSport"
#define kEventDate @"date"
#define kTimeKey @"timeStamp"
#define kHostKey @"host"
#define kLocKey @"location"
#define kLatKey @"latitude"
#define kLongKey @"longitude"
#define kPlayersKey @"players"
#define kEquipmentKey @"equipment"

@implementation Connections{
    PickUpAppDelegate *appDelegate;
    AFHTTPSessionManager *manager;
}

-(id)init{
    appDelegate = [[UIApplication sharedApplication] delegate];
    return self;
}

-(void)registerUser:(NSDictionary *)params{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *lastTweetDate = [appDelegate lastTweetDate];
    NSString *dateStr = [dateFormatter stringFromDate:lastTweetDate];
    NSDictionary *parameters = @{@"date" : dateStr};
    
    [manager GET:@"register"
      parameters:parameters
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject objectForKey:@"tweets"] != nil) {
                 NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"tweets"];
                 //
                 // Add new (sorted) tweets to head of appDelegate.tweets array.
                 // If implementing delete, some older tweets may be purged.
                 // Invoke [self.tableView reloadData] if any changes.
                 //
                 for (int i = 0; i < arrayOfDicts.count; i++) {
                     if ([[arrayOfDicts[i] objectForKey:kIsDeletedKey] intValue] == 0) {
                         Event *event = [[Event alloc] init];
                         tweet.tweet_id = [arrayOfDicts[i] objectForKey:kTweetIDKey];
                         tweet.username = [arrayOfDicts[i] objectForKey:kUserNameKey];
                         tweet.isDeleted = [[arrayOfDicts[i] objectForKey:kIsDeletedKey] intValue];
                         tweet.tweet = [arrayOfDicts[i] objectForKey:kTweetKey];
                         tweet.time_stamp = [dateFormatter dateFromString:[arrayOfDicts[i] objectForKey:kDateKey]];
                         tweet.tweetAttributedString = [arrayOfDicts[i] objectForKey:kTweetAttributedStringKey];
                         [appDelegate.tweets insertObject:tweet atIndex:0];
                     }
                     else{
                         // If the tweet was deleted, go through the local tweet list and remove it
                         for (int j = 0; j < arrayOfDicts.count; j++) {
                             NSNumber *spot = [arrayOfDicts[i] objectForKey:kTweetIDKey];
                             for (int i = 0; i < appDelegate.tweets.count; i++) {
                                 Tweet *temp = [appDelegate.tweets objectAtIndex:i];
                                 if (spot == temp.tweet_id) {
                                     [appDelegate.tweets removeObjectAtIndex:i];
                                     break;
                                 }
                             }
                         }
                     }
                 }
                 if (arrayOfDicts.count > 0) {
                     [self.tableView reloadData];
                 }
             }
             [self.refreshControl endRefreshing];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"in failure");
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             //
             // Display AlertView with appropriate error message.
             //
             if (statuscode == 503) {
                 
             }
             [self.refreshControl endRefreshing];
         }];

}

@end
