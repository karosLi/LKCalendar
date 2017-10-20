//
//  Demo4ViewController.m
//  LKCalendar
//
//  Created by karos li on 2017/7/11.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "Demo5ViewController.h"
#import "LKCalendar.h"

@interface Demo5ViewController () <LKCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LKCalendarView *calendarView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *stringArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray<NSDate *> *eventDates;

@end

@implementation Demo5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:253.0 / 255.0 green:159.0 / 255.0 blue:17.0 / 255.0 alpha:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToday)];
    
    [self.view addSubview:self.calendarView];
    [self.view addSubview:self.tableView];
    
    NSDate *now = [NSDate date];
    [self.eventDates addObject:now];
    [self.eventDates addObjectsFromArray:[self generateNextDaysEventOfQuanlity:8 fromDay:now]];
    NSDate *nextMonth = [now lk_nextMonth];
    [self.eventDates addObjectsFromArray:[self generateNextDaysEventOfQuanlity:10 fromDay:nextMonth]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendarView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.calendarView.frame));
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stringArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.stringArray[indexPath.row];
    
    return cell;
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
        config.menuHeight = 40;
        config.menuTextColor = [UIColor colorWithWhite:1 alpha:0.6];
        config.monthHeight = 0;
        config.dayTextColor = [UIColor whiteColor];
        config.selectedDayBackgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        
        NSDate *previousMonth = [[NSDate date] lk_previousMonth];
        
        _calendarView = [[LKCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 400) config:config];
        _calendarView.monthsDataSourse = @[previousMonth];
        _calendarView.delegate = self;
    }
    
    return _calendarView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        tableView.tableFooterView = [UIView new];
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSArray<NSString *> *)stringArray {
    if (!_stringArray) {
        NSMutableArray *stringArray = @[].mutableCopy;
        for (NSInteger i = 1; i <= 20; i++) {
            NSString *string = [NSString stringWithFormat:@"你是猴子派来的逗比 %zd 吗", i];
            [stringArray addObject:string];
        }
        
        _stringArray = [stringArray copy];
    }
    
    return _stringArray;
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
