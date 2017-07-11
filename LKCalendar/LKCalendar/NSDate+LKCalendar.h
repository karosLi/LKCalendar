//
//  NSDate+LKCalendar.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LKCalendar)

- (NSInteger)lk_numberOfDaysOfMonth;
- (NSInteger)lk_numberOfWeeksOfMonth;
- (NSInteger)lk_firstWeekDayOfMonth;
- (NSDate *)lk_nextMonth;
- (NSDate *)lk_previousMonth;
- (NSInteger)lk_day:(NSDate *)date;

+ (NSDate *)lk_setDay:(NSInteger)day toMonth:(NSDate *)month;
+ (BOOL)lk_isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;

@end
