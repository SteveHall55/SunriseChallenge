//
//  Event.h
//  SunriseChallenge
//
//  Created by Steve Hall on 3/24/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSDate *eventStartDate;
@property (strong, nonatomic) NSDate *eventDate;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *eventType;
@property (strong, nonatomic) NSString *longDescription;
@property (nonatomic) BOOL isAllDayEvent;

@end
