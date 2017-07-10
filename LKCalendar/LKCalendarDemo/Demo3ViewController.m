//
//  Demo3ViewController.m
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "Demo3ViewController.h"
#import "LKCalendar.h"

@interface Demo3ViewController ()

@property (nonatomic, strong) LKCalendarView *calendarView;

@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.calendarView];
}

#pragma mark - getter and setter
- (LKCalendarView *)calendarView {
    if (!_calendarView) {
        LKCalendarConfig *config = [[LKCalendarConfig alloc] init];
        config.isPagingEnabled = YES;
        config.totalNumberOfyears = 2;
        
        _calendarView = [[LKCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400) config:config];
    }
    
    return _calendarView;
}

@end
