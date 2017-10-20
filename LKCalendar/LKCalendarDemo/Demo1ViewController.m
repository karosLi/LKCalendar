//
//  Demo1ViewController.m
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "Demo1ViewController.h"
#import "LKCalendar.h"

@interface Demo1ViewController () <LKCalendarViewDelegate>

@property (nonatomic, strong) LKCalendarView *calendarView;

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToday)];
    
    [self.view addSubview:self.calendarView];
}

#pragma mark - LKCalendarViewDelegate
- (void)calendarView:(LKCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSLog(@"%@", date);
}

#pragma mark - event response
- (void)onClickToday {
    [self.calendarView scrollToToday:YES];
}

#pragma mark - getter and setter
- (LKCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[LKCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 400) config:nil];
        _calendarView.totalNumberOfyears = 2;
        _calendarView.backgroundColor = [UIColor whiteColor];
        _calendarView.delegate = self;
    }
    
    return _calendarView;
}

@end
