//
//  Event.h
//  PickUp
//
//  Created by Jenny Pessa on 4/5/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject <NSCopying, NSCoding>

@property (assign, nonatomic) NSInteger event_id;
@property (strong, nonatomic) NSString *eventSport;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *eventDate;
@property (strong, nonatomic) NSDate *timeStamp;
@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *location;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) NSMutableArray *equipment;

-(id)init;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)copyWithZone:(NSZone *)zone;


@end
