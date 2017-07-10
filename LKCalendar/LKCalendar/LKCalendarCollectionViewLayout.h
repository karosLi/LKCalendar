//
//  LKCalendarCollectionViewLayout.h
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCalendarCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) NSDate *currentMonth;
@property (nonatomic, strong) NSMutableArray<NSDate *> *dates;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize headerReferenceSize;

- (CGFloat)wholeSectionHeightAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)sectionFrameAtIndexPath:(NSIndexPath *)indexPath;

@end
