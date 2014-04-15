//
//  Connection.h
//  PickUp
//
//  Created by Ethan G Schulze on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionResponse.h"

@interface Connection : NSObject


-(id)init;
-(ConnectionResponse*)loginWithUsername:(NSString*)username Password:(NSString*)password;
-(ConnectionResponse*)registerWithUsername:(NSString*)username Password:(NSString*)password EMail:(NSString*)email;
-(ConnectionResponse*)addEventWithEventID:(NSInteger)event_id Sport:(NSString*)sport Name:(NSString*)name Date:(NSDate*)date TimeStamp:(NSDate*)time Host:(NSString*)host Location:(NSString*)location Latitude:(NSNumber*)latitude Longitude:(NSNumber*)longitude Players:(NSMutableArray*)players Equipment:(NSMutableArray*)equipment;
-(ConnectionResponse*)getEventsAfter:(NSDate*)time;
-(ConnectionResponse*)modEventWithEventID:(NSInteger)event_id Username:(NSString*)username IsDeleted:(BOOL)isDeleted;

@end
