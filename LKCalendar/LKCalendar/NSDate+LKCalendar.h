//
//  NSDate+LKCalendar.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LKCalendar)

- (NSDate *)lk_firstDayOfMonth;
- (NSDate *)lk_lastDayOfMonth;
- (NSInteger)lk_numberOfDaysOfMonth;
- (NSInteger)lk_numberOfWeeksOfMonth;
- (NSInteger)lk_firstWeekDayOfMonth;
- (NSDate *)lk_nextMonth;
- (NSDate *)lk_nextMonth:(NSUInteger)number;
- (NSDate *)lk_previousMonth;
- (NSDate *)lk_previousMonth:(NSUInteger)number;
- (NSDate *)lk_nextDay;
- (NSDate *)lk_nextDay:(NSUInteger)number;
- (NSDate *)lk_previousDay;
- (NSDate *)lk_previousDay:(NSUInteger)number;
- (NSInteger)lk_day;
- (NSInteger)lk_monthIntervalToDate:(NSDate *)toDate;

+ (NSDate *)lk_setDay:(NSInteger)day toMonth:(NSDate *)month;
+ (BOOL)lk_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;

@end
