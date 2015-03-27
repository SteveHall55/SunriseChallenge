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

// Get the first day of the week given weekOfYear and year
+(NSDate*)getFirstDayOfWeekWithWeekOfYear:(NSInteger)weekOfYear usingYear:(NSInteger)year;

// Get the date given the week, year, and weekDay values
+(NSDate*)getDateWithWeekOfYear:(NSInteger)weekOfYear year:(NSInteger)year weekDay:(NSInteger)weekDay;

// Get weekOfYear from a date
+(NSInteger)getWeekOfYearFromDate:(NSDate *)theDate;

// Get year from a date
+(NSInteger)getYearFromDate:(NSDate *)theDate;

 // Get the month string corresponding to the month number
+(NSString*)getMonthString:(int)index;

// Update the time of a given date
+(NSDate*)updateTimeForDate:(NSDate*)theDate hour:(NSInteger)hour minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

// Get a nicely formatted date string that we can display in section headers
+(NSString*)getFormattedDateString:(NSDate *)theDate;

// Compares two dates and ignores the time
+(BOOL)isSameDate:(NSDate*)date1 otherDate:(NSDate*)date2;

@end
