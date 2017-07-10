//
//  LKCalendarSectionView.m
//  LKCalendar
//
//  Created by karos li on 2017/7/8.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarSectionView.h"

@interface LKCalendarSectionView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation LKCalendarSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupView];
    
    return self;
}

- (void)setupView {
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(25.5, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

#pragma mark - getter and setter
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    }
    
    return _textLabel;
}

@end
