//
//  LKCalendarView.h
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCalendarConfig.h"

@class LKCalendarView;

@protocol LKCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(LKCalendarView *)calendarView scrollToMonth:(NSDate *)month withMonthHeight:(CGFloat)monthHeight;
- (void)calendarView:(LKCalendarView *)calendarView didSelectDate:(NSDate *)date;
- (NSInteger)calendarView:(LKCalendarView *)calendarView numberOfEventsForDate:(NSDate *)date;

@end

@interface LKCalendarView : UIView

@property (nonatomic, weak) id<LKCalendarViewDelegate> delegate;

/**
 是否需要分页, 默认不分页
 */
@property (nonatomic, assign) BOOL isPagingEnabled;

/**
 总共显示的年数范围，默认两年，由内部自己计算月份范围，如果是开启了分页，就不受此范围限制
 */
@property (nonatomic, assign) NSInteger totalNumberOfyears;

/**
 外部配置月份数据源，如果是开启了分页，就不受此范围限制，优先取 monthsDataSourse，其次取totalNumberOfyears
 */
@property (nonatomic, copy) NSArray<NSDate *> *monthsDataSourse;

- (instancetype)initWithFrame:(CGRect)frame config:(LKCalendarConfig *)config;

- (void)scrollToToday:(BOOL)animated;
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;
- (void)selectDate:(NSDate *)date;
- (void)reloadData;

@end
