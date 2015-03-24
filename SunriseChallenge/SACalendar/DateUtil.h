//
//  DateUtil.h
//  SunriseChallenge
//
//  Created by Steve Hall on 3/23/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

// Get the current year
+(NSString*)getCurrentYear;

// Get the current week of the year (1-53)
+(NSString*)getCurrentWeekOfYear;

//Get the first day of the week given weekOfYear and year
+(NSDate*)getFirstDayOfWeekWithWeekOfYear:(NSInteger)weekOfYear usingYear:(NSInteger)year;

 // Get the month string corresponding to the month number
+(NSString*)getMonthString:(int)index;

@end
