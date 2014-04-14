//
//  Connections.h
//  PickUp
//
//  Created by Matthew Steven Pessa on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connections : NSObject

-(void)refreshEvents:(NSDictionary*)params;
-(void)addEvent:(NSDictionary*)params;
-(void)registerUser:(NSDictionary*)params;
-(void)loginUser:(NSDictionary*)params;
-(void)deleteEvent:(NSDictionary*)params;
-(void)modEvent:(NSDictionary*)params;

@end
