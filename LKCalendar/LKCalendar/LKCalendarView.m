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

@interface LKCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) LKCalendarMenuView *menuView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LKCalendarCollectionViewLayout *layout;

@property (nonatomic, strong) NSDate *currentMonth;
@property (nonatomic, strong) NSMutableArray<NSDate *> *dates;
@property (nonatomic, strong) LKCalendarConfig *config;

@property (nonatomic, assign) BOOL wasScrolledToToday;
@property (nonatomic, assign) BOOL wasFirstDidDisplay;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation LKCalendarView

- (instancetype)initWithFrame:(CGRect)frame config:(LKCalendarConfig *)config {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.config = config ? config : [[LKCalendarConfig alloc] init];;
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
    self.menuView.textColor = self.config.menuTextColor;
    self.layout.headerHeight = self.config.monthHeight;
}

- (void)updateDataSourse {
    [self.dates removeAllObjects];
    if (self.monthsDataSourse.count > 0) {
        [self.dates addObjectsFromArray:self.monthsDataSourse];
    } else {
        if (self.totalNumberOfyears <= 0) {
            self.totalNumberOfyears = 2;
        }
        
        NSInteger monthQuanlityToAdd;
        monthQuanlityToAdd = 12 * self.totalNumberOfyears / 2;
        if (self.isPagingEnabled) {
            monthQuanlityToAdd = 6;
        }
        
        [self.dates addObject:self.currentMonth];
        [self addPreviousMonthsOfQuanlity:monthQuanlityToAdd];
        [self addNextMonthsOfQuanlity:monthQuanlityToAdd];
    }
    
    self.layout.dates = self.dates;
}

- (void)selectTodayWhenInitIfNeed {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.wasScrolledToToday) {
            self.wasScrolledToToday = YES;
            [self scrollToToday:NO];
            [self selectToday];
        }
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.menuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.config.menuHeight);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.config.menuHeight);
}

#pragma mark - public methods
- (void)setIsPagingEnabled:(BOOL)isPagingEnabled {
    _isPagingEnabled = isPagingEnabled;
    [self updateDataSourse];
    [self reloadData];
    [self selectTodayWhenInitIfNeed];
}

- (void)setTotalNumberOfyears:(NSInteger)totalNumberOfyears {
    _totalNumberOfyears = totalNumberOfyears > 0 ? totalNumberOfyears : 2 ;
    [self updateDataSourse];
    [self reloadData];
    [self selectTodayWhenInitIfNeed];
}

- (void)setMonthsDataSourse:(NSArray<NSDate *> *)monthsDataSourse {
    _monthsDataSourse = [monthsDataSourse copy];
    [self updateDataSourse];
    [self reloadData];
    [self selectTodayWhenInitIfNeed];
}

- (void)setAllowsDisplayDayOutOfMonth:(BOOL)allowsDisplayDayOutOfMonth {
    _allowsDisplayDayOutOfMonth = allowsDisplayDayOutOfMonth;
    [self reloadData];
}

- (void)scrollToToday:(BOOL)animated {
    [self scrollToDate:self.currentMonth animated:animated];
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated {
    NSInteger monthInterval = [[self.dates.firstObject lk_firstDayOfMonth] lk_monthIntervalToDate:date];
    if (monthInterval >= self.dates.count) {
        monthInterval = 0;
    }
    
    NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:monthInterval];
    
    CGRect sectionFrame = [self.layout sectionFrameAtIndexPath:sectionIndexPath];
    [self.collectionView setContentOffset:CGPointMake(0, sectionFrame.origin.y - self.collectionView.contentInset.top) animated:animated];
    [self restoreSelection];
    [self proxyScrollToMonth:date sectionIndexPath:sectionIndexPath];
}

- (void)selectDate:(NSDate *)date {
    NSInteger day = [date lk_day];
    NSInteger monthInterval = [[self.dates.firstObject lk_firstDayOfMonth] lk_monthIntervalToDate:date];
    if (monthInterval < self.dates.count) {
        NSInteger firstWeekDay = [date lk_firstWeekDayOfMonth];
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForItem:day - 1 + firstWeekDay inSection:monthInterval];
        [self.collectionView selectItemAtIndexPath:selectIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        self.selectedDate = date;
        [self proxyDidSelectDate:date];
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
    [self restoreSelection];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dates.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger weeks = [self.dates[section] lk_numberOfWeeksOfMonth];
    return weeks * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LKCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LKCalendarCell class]) forIndexPath:indexPath];
    
    BOOL isOutOfMonth = YES;
    NSDate *month = self.dates[indexPath.section];
    NSDate *dayDate = [self fetchDateWithMonth:month atIndexPath:indexPath isOutOfMonth:&isOutOfMonth];
    
    if (dayDate == 0) {
        cell.textLabel.text = @"";
    } else {
        if ([NSDate lk_isDate:self.currentMonth inSameDayAsDate:dayDate]) {
            cell.textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
            cell.textLabel.text = @"今天";
        } else {
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            cell.textLabel.text = [@([dayDate lk_day]) stringValue];
        }
    }
    
    cell.userInteractionEnabled = dayDate != nil;
    cell.dayTextColor = isOutOfMonth ? self.config.dayOutOfMonthTextColor : self.config.dayTextColor;
    cell.dayTextFont = self.config.dayTextFont;
    cell.selectedDayBackgroundColor = self.config.selectedDayBackgroundColor;
    
    cell.eventView = nil;
    UIView *eventView = [self proxyEventView:dayDate];
    if (eventView) {
        cell.eventView = eventView;
    } else {
        cell.hasEvent = [self proxyNumberOfEvent:dayDate] > 0;
    }
    
    [cell configureCell];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LKCalendarSectionView *section = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([LKCalendarSectionView class]) forIndexPath:indexPath];
    section.textLabel.text = [[self dateFormatter] stringFromDate:self.dates[indexPath.section]];
    section.textLabel.textColor = self.config.monthTextColor;
    
    return section;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *month = self.dates[indexPath.section];
    NSDate *dayDate = [self fetchDateWithMonth:month atIndexPath:indexPath isOutOfMonth:nil];
    
    return dayDate ? YES : NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *month = self.dates[indexPath.section];
    NSDate *dayDate = [self fetchDateWithMonth:month atIndexPath:indexPath isOutOfMonth:nil];
    self.selectedDate = dayDate;
    [self proxyDidSelectDate:dayDate];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isPagingEnabled) {
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
    if (self.isPagingEnabled) {
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
        
        [self restoreSelection];
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
- (void)selectToday {
    [self selectDate:self.currentMonth];
}

- (void)restoreSelection {
    if (self.selectedDate) {
        NSDate *date = self.selectedDate;
        NSInteger day = [date lk_day];
        NSInteger monthInterval = [[self.dates.firstObject lk_firstDayOfMonth] lk_monthIntervalToDate:date];
        if (monthInterval >= self.dates.count) {
            monthInterval = 0;
        }
        
        NSInteger firstWeekDay = [date lk_firstWeekDayOfMonth];
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForItem:day - 1 + firstWeekDay inSection:monthInterval];
        [self.collectionView selectItemAtIndexPath:selectIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (NSDate *)fetchDateWithMonth:(NSDate *)month atIndexPath:(NSIndexPath *)indexPath isOutOfMonth:(BOOL *)isOutOfMonth {
    NSDate *dayDate = nil;
    
    NSInteger firstWeekDay = [month lk_firstWeekDayOfMonth];
    NSInteger lastDayOfMonth = [[month lk_lastDayOfMonth] lk_day];
    
    if (indexPath.item < firstWeekDay) {
        // 上个月
        if (self.allowsDisplayDayOutOfMonth) {
            NSDate *previousMonth = [month lk_previousMonth];
            NSDate *lastDayOfPreviousMonth = [previousMonth lk_lastDayOfMonth];
            NSDate *previousDay = [lastDayOfPreviousMonth lk_previousDay:firstWeekDay - (indexPath.item + 1)];
            dayDate = previousDay;
            if (isOutOfMonth) {
                *isOutOfMonth = YES;
            }
        }
    } else if (indexPath.item >= firstWeekDay && indexPath.item < firstWeekDay + lastDayOfMonth) {
        // 本月
        dayDate = [NSDate lk_setDay:(indexPath.item + 1) - firstWeekDay toMonth:month];
        if (isOutOfMonth) {
            *isOutOfMonth = NO;
        }
    } else {
        // 下个月
        if (self.allowsDisplayDayOutOfMonth) {
            NSDate *nextMonth = [month lk_nextMonth];
            NSDate *firstDayOfNextMonth = [nextMonth lk_firstDayOfMonth];
            NSDate *nextDay = [firstDayOfNextMonth lk_nextDay:indexPath.item - (firstWeekDay + lastDayOfMonth)];
            dayDate = nextDay;
            if (isOutOfMonth) {
                *isOutOfMonth = YES;
            }
        }
    }
    
    return dayDate;
}

#pragma mark - delegate callback

- (void)proxyScrollToMonth:(NSDate *)date sectionIndexPath:(NSIndexPath *)sectionIndexPath {
    if ([self.delegate respondsToSelector:@selector(calendarView:scrollToMonth:withMonthHeight:)]) {
        NSDate *scrollToMonthDate = date;
        CGFloat wholeMonthHeight = [self.layout wholeSectionHeightAtIndexPath:sectionIndexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate calendarView:self scrollToMonth:scrollToMonthDate withMonthHeight:self.config.menuHeight + wholeMonthHeight];
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

- (UIView *)proxyEventView:(NSDate *)date {
    if ([self.delegate respondsToSelector:@selector(calendarViewEventView:forDate:)]) {
        return [self.delegate calendarViewEventView:self forDate:date];
    }
    
    return nil;
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
        _collectionView.backgroundColor = [UIColor clearColor];
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

