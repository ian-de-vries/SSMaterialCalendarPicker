//
//  NSDate+SSDateAdditions.h
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/17/15.
//  Copyright © 2015 Shoryuken Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SSDateAdditions)

- (NSDate *)defaultTime;
- (NSDate *)firstDayOfTheMonth;
+ (NSDate *)tomorrow;
+ (NSDate *)daysFromNow:(NSInteger)days;
- (NSDate *)addDays:(NSInteger)days;
- (BOOL)isDateBetween:(NSDate *)date1 and:(NSDate *)date2;
+ (int)daysBetween:(NSDate *)date1 and:(NSDate *)date2;
+ (int)daysFromLastSunday;
- (NSDate *)addMonths:(NSInteger)months;

@end
