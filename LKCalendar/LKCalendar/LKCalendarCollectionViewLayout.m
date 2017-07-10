//
//  LKCalendarCollectionViewLayout.m
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarCollectionViewLayout.h"
#import "NSDate+LKCalendar.h"
#import "NSCalendar+LKCalendar.h"

static NSString *kCellKind = @"kCellKind";

@interface LKCalendarCollectionViewLayout ()

@property (nonatomic, strong) NSMutableDictionary *layoutInformation;
@property (nonatomic, assign) CGFloat totalHeight;

@end

@implementation LKCalendarCollectionViewLayout

#pragma mark - public methods

- (CGFloat)wholeSectionHeightAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalHeight = 0;
    
    NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
    UICollectionViewLayoutAttributes *supplementaryAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
    
    NSInteger numItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:numItems - 1 inSection:indexPath.section];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    totalHeight = CGRectGetMaxY(attributes.frame);
    totalHeight -= supplementaryAttributes.frame.origin.y;
    
    return totalHeight;
}

- (CGRect)sectionFrameAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
    UICollectionViewLayoutAttributes *supplementaryAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
    
    return supplementaryAttributes.frame;
}

#pragma mark - layout
- (void)prepareLayout {
    [super prepareLayout];
    
    self.totalHeight = 0;
    [self.layoutInformation removeAllObjects];
    
    NSMutableDictionary *supplementaryInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numSections; section++){
        indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *supplementaryAttributes = [self sectionLayoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath topY:self.totalHeight];
        [supplementaryInfo setObject:supplementaryAttributes forKey:indexPath];
        self.totalHeight = CGRectGetMaxY(supplementaryAttributes.frame);
        
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger item = 0; item < numItems; item++){
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self cellLayoutAttributesForItemAtIndexPath:indexPath topY:self.totalHeight];
            [cellInformation setObject:attributes forKey:indexPath];
            
            if (item == numItems - 1) {
                self.totalHeight = CGRectGetMaxY(attributes.frame);
            }
        }
    }
    
    [self.layoutInformation setObject:supplementaryInfo forKey:UICollectionElementKindSectionHeader];
    [self.layoutInformation setObject:cellInformation forKey:kCellKind];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for(NSString *key in self.layoutInformation){
        NSDictionary *attributesDict = [self.layoutInformation objectForKey:key];
        for(NSIndexPath *key in attributesDict){
            UICollectionViewLayoutAttributes *attributes =
            [attributesDict objectForKey:key];
            if(CGRectIntersectsRect(rect, attributes.frame)){
                [myAttributes addObject:attributes];
            }
        }
    }
    
    return myAttributes;
}

/** CollectionView 添加删除动画需要使用 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
     return self.layoutInformation[kCellKind][indexPath];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInformation[elementKind][indexPath];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.totalHeight);
}

#pragma mark - private methods
- (nullable UICollectionViewLayoutAttributes *)sectionLayoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath topY:(CGFloat)topY {
    UICollectionViewLayoutAttributes *supplementaryAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    supplementaryAttributes.frame = CGRectMake(0, topY, self.collectionView.bounds.size.width, 22);
    
    return supplementaryAttributes;
}

- (UICollectionViewLayoutAttributes *)cellLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath topY:(CGFloat)topY {
    NSDate *currentMonth = self.dates[indexPath.section];
    
    // 获取 indexPath 位置的布局属性
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 计算每一个 Item 的 frame
    CGFloat sectionLeftPadding = self.collectionView.contentInset.left;
    CGFloat sectionRightPadding = self.collectionView.contentInset.right;
    // size
    CGFloat itemWidth = (self.collectionView.bounds.size.width - sectionLeftPadding - sectionRightPadding - 6 * self.minimumInteritemSpacing) / 7.0;
    CGFloat itemHeigh = itemWidth;
    // origin
    CGFloat itemX = (([currentMonth lk_firstWeekDayOfMonth] + indexPath.item) % 7) * (itemWidth + self.minimumInteritemSpacing);
    CGFloat itemY = (([currentMonth lk_firstWeekDayOfMonth] + indexPath.item) / 7) * itemHeigh;
    layoutAttributes.frame = CGRectMake(itemX, topY + itemY, itemWidth, itemHeigh);
    // 返回 indexPath 位置的 Item 的布局属性
    return layoutAttributes;
}

#pragma mark - getter and setter
- (NSMutableDictionary *)layoutInformation {
    if(!_layoutInformation){
        _layoutInformation = [[NSMutableDictionary alloc] init];
    }
    
    return _layoutInformation;
}

@end
