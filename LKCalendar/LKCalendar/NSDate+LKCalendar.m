//
//  NSDate+LKCalendar.m
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "NSDate+LKCalendar.h"
#import "NSCalendar+LKCalendar.h"

@implementation NSDate (LKCalendar)

- (NSDate *)lk_firstDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_firstDayOfMonth:self];
}

- (NSDate *)lk_lastDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_lastDayOfMonth:self];
}

- (NSInteger)lk_numberOfDaysOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_numberOfDaysInMonth:self];
}

- (NSInteger)lk_numberOfWeeksOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_numberOfWeeksInMonth:self];
}

- (NSInteger)lk_firstWeekDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_firstWeekDayInMonth:self];
}

- (NSDate *)lk_nextMonth:(NSUInteger)number {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = number;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lk_nextMonth {
    return [self lk_nextMonth:1];
}

- (NSDate *)lk_previousMonth:(NSUInteger)number {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -number;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lk_previousMonth {
    return [self lk_previousMonth:1];
}

- (NSDate *)lk_nextDay:(NSUInteger)number {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = number;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lk_nextDay {
    return [self lk_nextDay:1];
}

- (NSDate *)lk_previousDay:(NSUInteger)number {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -number;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lk_previousDay {
    return [self lk_previousDay:1];
}

- (NSInteger)lk_day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_day:self];
}

- (NSInteger)lk_monthIntervalToDate:(NSDate *)toDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMonth fromDate:self toDate:toDate options:0].month;
}

+ (NSDate *)lk_setDay:(NSInteger)day toMonth:(NSDate *)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_setDay:day toMonth:month];
}

+ (BOOL)lk_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDate:date1 inSameDayAsDate:date2];
}


@end
