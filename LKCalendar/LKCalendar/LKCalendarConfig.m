//
//  LKCalendarConfig.m
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarConfig.h"

@implementation LKCalendarConfig

- (instancetype)init {
    self = [super init];
    self.menuHeight = 62;
    self.menuTextColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.monthHeight = 22;
    self.monthTextColor = [UIColor blackColor];
    self.dayTextColor = [UIColor blackColor];
    self.selectedDayBackgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    return self;
}

@end
