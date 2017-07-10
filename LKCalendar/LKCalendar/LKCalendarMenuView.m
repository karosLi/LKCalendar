//
//  LKCalendarMenuView.m
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarMenuView.h"
#import "LKCalendarMenuCell.h"

@interface LKCalendarMenuView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray<NSString *> *weeks;

@end

@implementation LKCalendarMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupView];
    
    return self;
}

- (void)setupView {
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.contentInset = self.contentInset;
    CGFloat sectionLeftPadding = self.collectionView.contentInset.left;
    CGFloat sectionRightPadding = self.collectionView.contentInset.right;
    CGFloat itemWidth = (self.collectionView.bounds.size.width - sectionLeftPadding - sectionRightPadding - 5 * self.minimumInteritemSpacing) / 7.0;
    
    self.layout.itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
    
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.weeks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKCalendarMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LKCalendarMenuCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = self.weeks[indexPath.row];
    
    return cell;
}

#pragma mark - getter and setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[LKCalendarMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([LKCalendarMenuCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    
    return _layout;
}

- (NSArray<NSString *> *)weeks {
    if (!_weeks) {
        _weeks = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    }
    
    return _weeks;
}

@end
