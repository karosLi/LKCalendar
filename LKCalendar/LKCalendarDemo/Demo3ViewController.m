//
//  Demo3ViewController.m
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "Demo3ViewController.h"
#import "LKCalendar.h"

@interface Demo3ViewController () <LKCalendarViewDelegate>

@property (nonatomic, strong) LKCalendarView *calendarView;

@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(onClickToday)];
    
    [self.view addSubview:self.calendarView];
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

#pragma mark - event response
- (void)onClickToday {
    [self.calendarView scrollToToday:YES];
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

@end
