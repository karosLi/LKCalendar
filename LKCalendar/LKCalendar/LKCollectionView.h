//
//  LKCollectionView.h
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKCollectionView;

@protocol LKCollectionViewDelegate <UICollectionViewDelegate>

- (void)collectionViewWillLayoutSubviews:(LKCollectionView *)collectionView;

@end

@interface LKCollectionView : UICollectionView

@property (nonatomic, weak) id <LKCollectionViewDelegate> lk_delegate;

@end
