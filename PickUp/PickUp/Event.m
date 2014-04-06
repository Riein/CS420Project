//
//  Event.m
//  PickUp
//
//  Created by Jenny Pessa on 4/5/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)init{

    if (self = [super init]) {
        self.event_id = 0;
        self.eventDate = [NSDate date];
        self.timeStamp = [NSDate date];
        self.host = @"";
        self.location = @"";
        self.latitude = [NSNumber numberWithDouble:0.0];
        self.longitude = [NSNumber numberWithDouble:0.0];
        self.players = [[NSMutableArray alloc] init];
        self.equipment = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#define kEventID @"event_id"
#define kEventDate @"date"
#define kTimeKey @"timeStamp"
#define kHostKey @"host"
#define kLocKey @"location"
#define kLatKey @"latitude"
#define kLongKey @"longitude"
#define kPlayersKey @"players"
#define kEquipmentKey @"equipment"

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.event_id = [aDecoder decodeObjectForKey:kEventID];
        self.eventDate = [aDecoder decodeObjectForKey:kEventDate];
        self.timeStamp = [aDecoder decodeObjectForKey:kTimeKey];
        self.host = [aDecoder decodeObjectForKey:kHostKey];
        self.location = [aDecoder decodeObjectForKey:kLocKey];
        self.latitude = [aDecoder decodeObjectForKey:kLatKey];
        self.longitude = [aDecoder decodeObjectForKey:kLongKey];
        self.players = [aDecoder decodeObjectForKey:kPlayersKey];
        self.equipment = [aDecoder decodeObjectForKey:kEquipmentKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.event_id forKey:kEventID];
    [aCoder encodeObject:self.eventDate forKey:kEventDate];
    [aCoder encodeObject:self.timeStamp forKey:kTimeKey];
    [aCoder encodeObject:self.host forKey:kHostKey];
    [aCoder encodeObject:self.location forKey:kLocKey];
    [aCoder encodeObject:self.latitude forKey:kLatKey];
    [aCoder encodeObject:self.longitude forKey:kLongKey];
    [aCoder encodeObject:self.players forKey:kPlayersKey];
    [aCoder encodeObject:self.equipment forKey:kEquipmentKey];
}

-(id)copyWithZone:(NSZone *)zone{
    Event *clone = [[[self class] alloc] init];
    clone.event_id = self.event_id;
    clone.eventDate = self.eventDate;
    clone.timeStamp = self.timeStamp;
    clone.host = self.host;
    clone.location = self.location;
    clone.latitude = self.latitude;
    clone.longitude = self.longitude;
    clone.players = self.players;
    clone.equipment = self.equipment;
    
    return clone;
}

@end
