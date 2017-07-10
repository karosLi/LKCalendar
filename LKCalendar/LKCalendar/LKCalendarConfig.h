//
//  LKCalendarConfig.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKCalendarConfig : NSObject

/**
 总共显示的年数范围，默认两年，如果是开启了分页，就不受此限制
 */
@property (nonatomic, assign) NSInteger totalNumberOfyears;

/**
 是否需要分页
 */
@property (nonatomic, assign) BOOL isPagingEnabled;

@end
