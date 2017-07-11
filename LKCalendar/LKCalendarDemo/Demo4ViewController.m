//
//  Demo4ViewController.m
//  LKCalendar
//
//  Created by karos li on 2017/7/11.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "Demo4ViewController.h"
#import "LKCalendar.h"

@interface Demo4ViewController () <LKCalendarViewDelegate>

@property (nonatomic, strong) LKCalendarView *calendarView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray<NSDate *> *eventDates;

@end

@implementation Demo4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToday)];
    
    [self.view addSubview:self.calendarView];
    
    NSDate *now = [NSDate date];
    [self.eventDates addObject:now];
    [self.eventDates addObjectsFromArray:[self generateNextDaysEventOfQuanlity:8 fromDay:now]];
    NSDate *nextMonth = [now lk_nextMonth];
    [self.eventDates addObjectsFromArray:[self generateNextDaysEventOfQuanlity:10 fromDay:nextMonth]];
}

#pragma mark - LKCalendarViewDelegate
- (void)calendarView:(LKCalendarView *)calendarView scrollToMonth:(NSDate *)month withMonthHeight:(CGFloat)monthHeight {
    CGRect rect = self.calendarView.frame;
    rect.size.height = monthHeight;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
        self.calendarView.frame = rect;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)calendarView:(LKCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"%@", date);
}

- (NSInteger)calendarView:(LKCalendarView *)calendarView numberOfEventsForDate:(NSDate *)date {
    
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    for (NSDate *eventDate in self.eventDates) {
        NSString *eventDateString = [self.dateFormatter stringFromDate:eventDate];
        if ([dateString isEqualToString:eventDateString]) {
            return 1;
        }
    }
    
    return 0;
}

#pragma mark - event response
- (void)onClickToday {
    [self.calendarView scrollToToday:YES];
}

#pragma mark - private methods
- (NSMutableArray<NSDate *> *)generateNextDaysEventOfQuanlity:(NSInteger)quanlity fromDay:(NSDate *)fromDay {
    NSDate *nextDay = fromDay;
    NSMutableArray<NSDate *> *days = @[].mutableCopy;
    for (NSInteger i = 0; i < quanlity; i++) {
        nextDay = [nextDay lk_nextDay];
        [days addObject:nextDay];
    }
    
    return days;
}

#pragma mark - getter and setter
- (LKCalendarView *)calendarView {
    if (!_calendarView) {
        LKCalendarConfig *config = [[LKCalendarConfig alloc] init];
        config.isPagingEnabled = YES;
        
        _calendarView = [[LKCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 400) config:config];
        _calendarView.delegate = self;
    }
    
    return _calendarView;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return _dateFormatter;
}

- (NSMutableArray<NSDate *> *)eventDates {
    if (!_eventDates) {
        _eventDates = @[].mutableCopy;
    }
    
    return _eventDates;
}

@end
