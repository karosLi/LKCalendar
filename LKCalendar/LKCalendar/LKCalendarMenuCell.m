//
//  LKCalendarMenuCell.m
//  LKCalendar
//
//  Created by karos li on 2017/7/10.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "LKCalendarMenuCell.h"

@interface LKCalendarMenuCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation LKCalendarMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupView];
    
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

#pragma mark - getter and setter
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    }
    
    return _textLabel;
}

@end
