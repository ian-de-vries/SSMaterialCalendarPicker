//
//  NSDate+SSDateAdditions.m
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/17/15.
//  Copyright © 2015 Shoryuken Solutions. All rights reserved.
//

#import "NSDate+SSDateAdditions.h"

@implementation NSDate (SSDateAdditions)

- (NSDate *)defaultTime {
    if (self == nil) return nil;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|
                               NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
                               NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
    [comps setHour:12];
    [comps setMinute:00];
    [comps setSecond:00];
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDate *)firstDayOfTheMonth {
    if (self == nil) return nil;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|
                               NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
                               NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
    [comps setDay:1];
    return [[NSCalendar currentCalendar] dateFromComponents:comps].defaultTime;
}

+ (NSDate *)tomorrow {
    return [self daysFromNow:1];
}

+ (NSDate *)daysFromNow:(NSInteger)days {
    NSDate *now = [NSDate date];
    int daysToAdd = (int)days;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    return newDate1;
}

- (NSDate *)addDays:(NSInteger)days {
    int daysToAdd = (int)days;
    NSDate *newDate1 = [self dateByAddingTimeInterval:60*60*24*daysToAdd];
    return newDate1;
}

- (BOOL)isDateBetween:(NSDate *)date1 and:(NSDate *)date2 {
    if (date1 == nil || date2 == nil) return NO;
    return ([self compare:date1] != NSOrderedAscending) && ([self compare:date2] != NSOrderedDescending);
}

+ (int)daysBetween:(NSDate *)date1 and:(NSDate *)date2 {
    if (date1 != nil && date2 != nil) {
        NSDate *fromDate;
        NSDate *toDate;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                     interval:NULL forDate:date1];
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                     interval:NULL forDate:date2];
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:fromDate toDate:toDate options:0];
        return (int)[difference day];
    } else return 0;
}

+ (int)daysFromLastSunday {
    int weekday = (int)[[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    return --weekday;
}

- (NSDate *)addMonths:(NSInteger)months {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:months];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

@end
