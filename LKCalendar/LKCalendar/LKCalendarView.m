//
//  LKCalendarView.m
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarView.h"
#import "LKCalendarCollectionViewLayout.h"
#import "LKCalendarCell.h"
#import "LKCalendarSectionView.h"
#import "LKCalendarMenuView.h"
#import "NSDate+LKCalendar.h"

#define kLKCalendarMenuViewHeight 62

@interface LKCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) LKCalendarMenuView *menuView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LKCalendarCollectionViewLayout *layout;

@property (nonatomic, strong) NSDate *currentMonth;
@property (nonatomic, strong) NSMutableArray<NSDate *> *dates;
@property (nonatomic, strong) LKCalendarConfig *config;

@property (nonatomic, assign) BOOL wasScrolledToToday;
@property (nonatomic, strong) NSMutableArray<NSDate *> *selectedDates;

@end

@implementation LKCalendarView

- (instancetype)initWithFrame:(CGRect)frame config:(LKCalendarConfig *)config {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.config = config;
    [self commonInit];
    [self setupView];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    [self setupView];
    
    return self;
}

- (void)setupView {
    [self addSubview:self.menuView];
    [self addSubview:self.collectionView];
}

- (void)commonInit {
    if (!self.config) {
        self.config = [[LKCalendarConfig alloc] init];
    }
    
    NSInteger monthQuanlityToAdd;
    if (self.config.totalNumberOfyears <= 0) {
        self.config.totalNumberOfyears = 2;
    }
    
    monthQuanlityToAdd = 12 * self.config.totalNumberOfyears / 2;
    if (self.config.isPagingEnabled) {
        monthQuanlityToAdd = 6;
    }
    
    [self.dates addObject:self.currentMonth];
    [self addPreviousMonthsOfQuanlity:monthQuanlityToAdd];
    [self addNextMonthsOfQuanlity:monthQuanlityToAdd];
    self.layout.dates = self.dates;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.menuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kLKCalendarMenuViewHeight);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kLKCalendarMenuViewHeight);
    if (!self.wasScrolledToToday) {
        self.wasScrolledToToday = YES;
        [self scrollToToday:NO];
        [self selectToday];
    }
}

#pragma mark - public methods
- (void)scrollToToday:(BOOL)animated {
    [self scrollToDate:self.currentMonth animated:animated];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dates.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dates[section] lk_numberOfDaysOfMonth];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LKCalendarCell class]) forIndexPath:indexPath];
    
    NSDate *month = self.dates[indexPath.section];
    NSDate *day = [NSDate lk_setDay:indexPath.item + 1 toMonth:month];
    if ([NSDate lk_isDate:self.currentMonth inSameDayAsDate:day]) {
        cell.textLabel.text = @"今天";
    } else {
        cell.textLabel.text = [@(indexPath.item + 1) stringValue];
    }
    
    cell.hasEvent = [self proxyNumberOfEvent:day];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LKCalendarSectionView *section = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LKCalendarSectionView class]) forIndexPath:indexPath];
    section.textLabel.text = [[self dateFormatter] stringFromDate:self.dates[indexPath.section]];
    
    return section;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *month = self.dates[indexPath.section];
    NSDate *day = [NSDate lk_setDay:indexPath.item + 1 toMonth:month];
    [self.selectedDates addObject:day];
    [self proxyDidSelectDate:day];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *month = self.dates[indexPath.section];
    NSDate *day = [NSDate lk_setDay:indexPath.item + 1 toMonth:month];
    
    for (NSDate *selectedDate in self.selectedDates) {
        if ([NSDate lk_isDate:selectedDate inSameDayAsDate:day]) {
            [self.selectedDates removeObject:selectedDate];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.config.isPagingEnabled) {
            if (scrollView.contentOffset.y < CGRectGetHeight(scrollView.bounds) * 2) {
                [self appendPastMonths];
            }
            
            if (scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds) * 2 > scrollView.contentSize.height) {
                [self appendFutureMonths];
            }
        }
    });
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.config.isPagingEnabled) {
        // 升序
        NSArray *sortedIndexPathsForVisibleItems = [[self.collectionView indexPathsForVisibleItems]  sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath * obj2) {
            return obj1.section > obj2.section;
        }];
        
        NSInteger visibleSection;
        NSInteger nextSection;
        if (velocity.y > 0.0) { // 加速度情况下 下一页
            NSArray *filterItems = [sortedIndexPathsForVisibleItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath  * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject item] == 0;
            }]];
            
            visibleSection = [[filterItems firstObject] section];
            nextSection = visibleSection + 1;
        } else if (velocity.y < 0.0) { // 加速度情况下 上一页
            // 由于一个月最小是28天，进行过滤只取出27号以后的 indexPath.
            NSArray *filterItems = [sortedIndexPathsForVisibleItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath  * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject item] > 26;
            }]];
            
            visibleSection = [[filterItems lastObject] section];
            nextSection = visibleSection - 1;
        } else { // 非加速度情况下，取中间 item 来决定去哪一页
            visibleSection = [sortedIndexPathsForVisibleItems[sortedIndexPathsForVisibleItems.count / 2] section];
            nextSection = visibleSection;
        }
        
        // 安全判断
        nextSection = MAX(MIN([self.collectionView numberOfSections] - 1, nextSection), 0);
        
        // 获取 section 的frame
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:nextSection];
        CGRect sectionFrame = [self.layout sectionFrameAtIndexPath:sectionIndexPath];
        
        // 设置最终 collectionView 的滚动位置
        CGPoint topOfHeader = CGPointMake(0, sectionFrame.origin.y - self.collectionView.contentInset.top);
        *targetContentOffset = topOfHeader;
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [self proxyScrollToMonth:[self.dates objectAtIndex:nextSection] sectionIndexPath:sectionIndexPath];
    }
}

#pragma mark - load more months
- (void)appendFutureMonths {
    // 向后添加月份
    [self addNextMonthsOfQuanlity:6];
    [self.collectionView reloadData];
}

- (void)appendPastMonths {
    NSArray *visibleCells = [self.collectionView visibleCells];
    if (![visibleCells count])
        return;
    
    // 记录当前正在显示的月份
    NSIndexPath *originSectionIndexPath = [self.collectionView indexPathForCell:((UICollectionViewCell *)visibleCells[0]) ];
    NSInteger originSection = originSectionIndexPath.section;
    NSDate *originSectionDate = [self.dates objectAtIndex:originSection];
    CGRect originSectionFrame = [self.layout sectionFrameAtIndexPath:originSectionIndexPath];
    
    // 向前添加月份
    [self addPreviousMonthsOfQuanlity:6];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    // 重新计算当前长在显示月份新的位置
    NSInteger nowSectionIndex = [self.dates indexOfObject:originSectionDate];
    NSIndexPath *nowSectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:nowSectionIndex];
    CGRect nowSectionFrame = [self.layout sectionFrameAtIndexPath:nowSectionIndexPath];
    
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + (nowSectionFrame.origin.y - originSectionFrame.origin.y))];
    [self restoreSelection];
}

- (void)addNextMonthsOfQuanlity:(NSInteger)quanlity {
    NSDate *lastMonth = self.dates.lastObject;
    NSDate *nextMonth = lastMonth;
    for (NSInteger i = 0; i < quanlity; i++) {
        nextMonth = [nextMonth lk_nextMonth];
        [self.dates addObject:nextMonth];
    }
}

- (void)addPreviousMonthsOfQuanlity:(NSInteger)quanlity {
    NSDate *firstMonth = self.dates.firstObject;
    NSDate *previousMonth = firstMonth;
    for (NSInteger i = 0; i < quanlity; i++) {
        previousMonth = [previousMonth lk_previousMonth];
        [self.dates insertObject:previousMonth atIndex:0];
    }
}

#pragma mark - private methods
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated {
    NSInteger monthInterval = [[self.dates.firstObject lk_firstDayOfMonth] lk_monthIntervalToDate:date];
    NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:monthInterval];
    
    CGRect sectionFrame = [self.layout sectionFrameAtIndexPath:sectionIndexPath];
    [self.collectionView setContentOffset:CGPointMake(0, sectionFrame.origin.y - self.collectionView.contentInset.top) animated:animated];
    [self restoreSelection];
    [self proxyScrollToMonth:date sectionIndexPath:sectionIndexPath];
}

- (void)selectToday {
    [self selectDate:self.currentMonth];
}

- (void)selectDate:(NSDate *)date {
    NSInteger day = [date lk_day];
    NSInteger monthInterval = [[self.dates.firstObject lk_firstDayOfMonth] lk_monthIntervalToDate:date];
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForItem:day - 1 inSection:monthInterval];
    [self.collectionView selectItemAtIndexPath:selectIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [self.selectedDates addObject:date];
    [self proxyDidSelectDate:date];
}

- (void)restoreSelection {
    if (self.selectedDates.count > 0) {
        NSDate *date = self.selectedDates[0];
        NSInteger day = [date lk_day];
        NSInteger monthInterval = [[self.dates.firstObject lk_firstDayOfMonth] lk_monthIntervalToDate:date];
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForItem:day - 1 inSection:monthInterval];
        [self.collectionView selectItemAtIndexPath:selectIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - delegate callback

- (void)proxyScrollToMonth:(NSDate *)date sectionIndexPath:(NSIndexPath *)sectionIndexPath {
    if ([self.delegate respondsToSelector:@selector(calendarView:scrollToMonth:withMonthHeight:)]) {
        NSDate *scrollToMonthDate = date;
        CGFloat wholeMonthHeight = [self.layout wholeSectionHeightAtIndexPath:sectionIndexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate calendarView:self scrollToMonth:scrollToMonthDate withMonthHeight:kLKCalendarMenuViewHeight + wholeMonthHeight];
        });
    }
}

- (void)proxyDidSelectDate:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:self didSelectDate:date];
    }
}

- (NSInteger)proxyNumberOfEvent:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(calendarView:numberOfEventsForDate:)]) {
        return [self.delegate calendarView:self numberOfEventsForDate:date];
    }
    
    return 0;
}

#pragma mark - getter and setter
- (LKCalendarMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[LKCalendarMenuView alloc] init];
    }
    
    return _menuView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[LKCalendarCell class] forCellWithReuseIdentifier:NSStringFromClass([LKCalendarCell class])];
        [_collectionView registerClass:[LKCalendarSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LKCalendarSectionView class])];
        _collectionView.frame = self.bounds;
        [_collectionView reloadData];
        [_collectionView layoutIfNeeded];
    }
    
    return _collectionView;
}

- (LKCalendarCollectionViewLayout *)layout {
    if (!_layout) {
        _layout = [[LKCalendarCollectionViewLayout alloc] init];
    }
    
    return _layout;
}

- (NSMutableArray<NSDate *> *)dates {
    if (!_dates) {
        _dates = [NSMutableArray array];
    }
    
    return _dates;
}

- (NSMutableArray<NSDate *> *)selectedDates {
    if (!_selectedDates) {
        _selectedDates = [NSMutableArray array];
    }
    
    return _selectedDates;
}

- (NSDate *)currentMonth {
    if (!_currentMonth) {
        _currentMonth = [NSDate date];
    }
    
    return _currentMonth;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy . M"];
    });
    
    return formatter;
}

@end
