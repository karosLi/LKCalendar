//
//  LKCalendarConfig.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCalendarConfig : NSObject

/**
 菜单高度, 默认值 62
 */
@property (nonatomic, assign) CGFloat menuHeight;

/**
 菜单文本颜色, 默认值为30%不透明的黑色
 */
@property (nonatomic, copy) UIColor *menuTextColor;

/**
 月份高度, 默认值 22
 */
@property (nonatomic, assign) CGFloat monthHeight;

/**
 月份颜色, 默认值为黑色
 */
@property (nonatomic, copy) UIColor *monthTextColor;

/**
 天文本颜色, 默认值为黑色
 */
@property (nonatomic, copy) UIColor *dayTextColor;

/**
 天文本选中背景颜色, 默认值为10%不透明的黑色
 */
@property (nonatomic, copy) UIColor *selectedDayBackgroundColor;

@end
