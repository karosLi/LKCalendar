//
//  LKCalendarCollectionViewLayout.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCalendarCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) NSMutableArray<NSDate *> *dates;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

/**
 返回整个月份的高度

 @param indexPath indexPath
 @return CGFloat
 */
- (CGFloat)wholeSectionHeightAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回月份的 frame

 @param indexPath indexPath
 @return CGRect
 */
- (CGRect)sectionFrameAtIndexPath:(NSIndexPath *)indexPath;

@end
