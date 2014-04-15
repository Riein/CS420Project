//
//  ConnectionResponse.h
//  PickUp
//
//  Created by Ethan G Schulze on 4/14/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionResponse : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic) NSString* response;
@property (nonatomic) int statusCode;

-(id)init;
-(id)initWithSuccess:(BOOL)success Response:(NSString*)response StatusCode:(int)statusCode;

@end
