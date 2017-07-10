//
//  LKCollectionView.m
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCollectionView.h"

@implementation LKCollectionView

- (void)layoutSubviews {
    if ([self.lk_delegate respondsToSelector:@selector(collectionViewWillLayoutSubviews:)]) {
        [self.lk_delegate collectionViewWillLayoutSubviews:self];
    }
    
    [super layoutSubviews];
}

@end
