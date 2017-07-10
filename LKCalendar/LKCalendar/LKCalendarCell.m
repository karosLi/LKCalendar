//
//  LKCalendarCell.m
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarCell.h"

@interface LKCalendarCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *eventView;

@end

@implementation LKCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupView];
    
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.eventView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.bgView.frame = CGRectMake((CGRectGetWidth(self.bounds) - 35) / 2, (CGRectGetHeight(self.bounds) - 35) / 2, 35, 35);
    self.eventView.frame = CGRectMake((CGRectGetWidth(self.bounds) - 5) / 2, CGRectGetHeight(self.bounds) - 5, 5, 5);
}

#pragma mark - getter and setter
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    }
    
    return _textLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.layer.cornerRadius = 35.0 / 2;
        _bgView.layer.masksToBounds = YES;
    }
    
    return _bgView;
}

- (UIView *)eventView {
    if (!_eventView) {
        _eventView = [UIView new];
        _eventView.backgroundColor = [UIColor colorWithRed:1 green:78.0 / 255.0 blue:0 alpha:1];
        _eventView.layer.cornerRadius = 5.0 / 2;
        _eventView.layer.masksToBounds = YES;
    }
    
    return _eventView;
}

@end
