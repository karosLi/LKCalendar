//
//  LKCalendarCell.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCalendarCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong) UIView *eventView;
@property (nonatomic, assign) BOOL hasEvent;
/**
 天文本颜色, 默认值为黑色
 */
@property (nonatomic, copy) UIColor *dayTextColor;

/**
 天文本选中背景颜色, 默认值为10%不透明的黑色
 */
@property (nonatomic, copy) UIColor *selectedDayBackgroundColor;

- (void)configureCell;

@end
