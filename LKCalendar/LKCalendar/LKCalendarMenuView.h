//
//  LKCalendarMenuView.h
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCalendarMenuView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/**
 菜单文本颜色, 默认值为30%不透明的黑色
 */
@property (nonatomic, copy) UIColor *textColor;

@end
