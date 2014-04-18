//
//  Connection.h
//  PickUp
//
//  Created by Ethan G Schulze on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject

-(id)init;
-(void)loginUser:(NSDictionary*)params;
-(void)registerUser:(NSDictionary*)params;
-(void)addEvent:(NSDictionary*)params;
-(void)getEvents:(NSDictionary*)params;
-(void)modEvent:(NSDictionary*)params;
-(void)deleteEvent:(NSDictionary*)params;
@property BOOL finished;

@end
