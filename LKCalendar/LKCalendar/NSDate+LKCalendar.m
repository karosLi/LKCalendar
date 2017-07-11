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

- (NSDate *)lk_nextMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)lk_previousMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSInteger)lk_day:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar lk_day:self];
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
