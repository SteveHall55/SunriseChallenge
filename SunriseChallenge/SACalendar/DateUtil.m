//
//  DateUtil.m
//  SunriseChallenge
//
//  Created by Steve Hall on 3/23/15.
//  Copyright (c) 2015 Steve Hall. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSString*)getCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    
    [formatter setCalendar:gregorianCalendar];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

+(NSString*)getCurrentWeekOfYear
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components = [gregorianCalendar components:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];

    return [NSString stringWithFormat:@"%ld", components.weekOfYear];
}

+(NSDate*)getFirstDayOfWeekWithWeekOfYear:(NSInteger)weekOfYear usingYear:(NSInteger)year
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.weekOfYear = weekOfYear;
    components.weekday = 1;
    // Set the time to be end of the day to help with date comparisons
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    return [gregorianCalendar dateFromComponents:components];
}

+(NSDate*)getDateWithWeekOfYear:(NSInteger)weekOfYear year:(NSInteger)year weekDay:(NSInteger)weekDay
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.weekOfYear = weekOfYear;
    components.weekday = weekDay;
    
    return [gregorianCalendar dateFromComponents:components];
}

+(NSInteger)getWeekOfYearFromDate:(NSDate *)theDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitWeekOfYear fromDate:theDate];
    
    return components.weekOfYear;
}

+(NSInteger)getYearFromDate:(NSDate *)theDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear fromDate:theDate];
    
    return components.year;
}

+(NSDate*)updateTimeForDate:(NSDate*)theDate hour:(NSInteger)hour minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:theDate];
    components.hour = hour;
    components.minute = minutes;
    components.second = seconds;
    
    return [gregorianCalendar dateFromComponents:components];
}

+(NSString*)getMonthString:(int)index
{
    NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sept",@"October",@"Nov",@"Dec", nil];
    return [months objectAtIndex:index-1];
}

+(NSString*)getFormattedDateString:(NSDate *)theDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:theDate];
    
    // Get the month as a string
    NSArray *months = [[NSArray alloc]initWithObjects:@"JANUARY",@"FEBRUARY",@"MARCH",@"APRIL",@"MAY",@"JUNE",@"JULY",@"AUGUST",@"SEPTEMBER",@"OCTOBER",@"NOVEMBER",@"DECEMBER", nil];
    NSString *monthString = [months objectAtIndex:components.month - 1];
    
    // Get the weekday as a string
    NSArray *daysInWeeks = [[NSArray alloc]initWithObjects:@"SUNDAY",@"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY",@"SATURDAY", nil];
    NSString *weekdayString = [daysInWeeks objectAtIndex:components.weekday - 1];
    
    return [NSString stringWithFormat:@"%@, %@ %d", weekdayString, monthString, (int)components.day];
}

+(BOOL)isSameDate:(NSDate*)date1 otherDate:(NSDate*)date2
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components1 = [gregorianCalendar components:unitFlags fromDate:date1];
    NSDateComponents *components2 = [gregorianCalendar components:unitFlags fromDate:date2];
    
    return ([components1 day] == [components2 day] &&
            [components1 month] == [components2 month] &&
            [components1 year]  == [components2 year]);
}

@end
