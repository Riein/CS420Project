//
//  ConnectionResponse.m
//  PickUp
//
//  Created by Ethan G Schulze on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "ConnectionResponse.h"

@implementation ConnectionResponse

-(id)init{
    if(self == nil){
        self = [super init];
        self.success = NO;
        self.response = nil;
        self.statusCode = 0;
    }
    return self;
}

-(id)initWithSuccess:(BOOL)success Response:(NSString*)response StatusCode:(int)statusCode{
    self = [super init];
    self.success = success;
    self.response = response;
    self.statusCode = statusCode;
    return self;
}

@end
