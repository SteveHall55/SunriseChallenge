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

+(NSString*)getMonthString:(int)index
{
    NSArray *months = [[NSArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sept",@"October",@"Nov",@"Dec", nil];
    return [months objectAtIndex:index-1];
}

@end
