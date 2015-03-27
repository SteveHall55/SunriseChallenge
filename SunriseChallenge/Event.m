//
//  Event.m
//  SunriseChallenge
//
//  Created by Steve Hall on 3/24/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.eventStartDate = nil;
        self.eventDate = nil;;
        self.duration = nil;
        self.title = nil;
        self.eventType = nil;
        self.longDescription = nil;
        self.isAllDayEvent = nil;
    }
    
    return self;
}

@end
