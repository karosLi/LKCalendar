//
//  NSCalendar+LKCalendar.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (LKCalendar)

- (NSDate *)lk_firstDayOfMonth:(NSDate *)month;
- (NSDate *)lk_lastDayOfMonth:(NSDate *)month;
- (NSDate *)lk_firstDayOfWeek:(NSDate *)week;
- (NSDate *)lk_lastDayOfWeek:(NSDate *)week;
- (NSInteger)lk_numberOfDaysInMonth:(NSDate *)month;
- (NSInteger)lk_numberOfWeeksInMonth:(NSDate *)month;
- (NSInteger)lk_firstWeekDayInMonth:(NSDate *)month;
- (NSInteger)lk_year:(NSDate *)date;
- (NSInteger)lk_month:(NSDate *)date;
- (NSInteger)lk_day:(NSDate *)date;
- (NSDate *)lk_setDay:(NSInteger)day toMonth:(NSDate *)month;

@end
