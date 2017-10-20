//
//  LKCalendarCell.m
//  LKCalendar
//
//  Created by karos li on 2017/7/7.
//  Copyright © 2017年 karos. All rights reserved.
//

#define LKCalendarBounceAnimationDuration 0.15

#import "LKCalendarCell.h"

@interface LKCalendarCell ()

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *eventLayer;
@property (nonatomic, strong) UILabel *textLabel;

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
    [self.contentView.layer addSublayer:self.bgLayer];
    [self.contentView addSubview:self.textLabel];
    [self.contentView.layer addSublayer:self.eventLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.bgLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - 35) / 2, (CGRectGetHeight(self.bounds) - 35) / 2, 35, 35);
    self.eventLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - 5) / 2, CGRectGetHeight(self.bounds) - 5, 5, 5);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.bgLayer.bounds
                                                cornerRadius:CGRectGetWidth(self.bgLayer.bounds) * 0.5].CGPath;
    if (!CGPathEqualToPath(self.bgLayer.path, path)) {
        self.bgLayer.path = path;
    }

    path = [UIBezierPath bezierPathWithRoundedRect:self.eventLayer.bounds
                                                cornerRadius:CGRectGetWidth(self.eventLayer.bounds) * 0.5].CGPath;
    if (!CGPathEqualToPath(self.eventLayer.path, path)) {
        self.eventLayer.path = path;
    }
}

- (void)setSelected:(BOOL)selected {
    BOOL originSelected = self.selected;
    [super setSelected:selected];
    
    if (selected && !originSelected) {
        CAAnimationGroup *group = [CAAnimationGroup animation];
        CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomOut.fromValue = @0.3;
        zoomOut.toValue = @1.2;
        zoomOut.duration = LKCalendarBounceAnimationDuration/4*3;
        CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        zoomIn.fromValue = @1.2;
        zoomIn.toValue = @1.0;
        zoomIn.beginTime = LKCalendarBounceAnimationDuration/4*3;
        zoomIn.duration = LKCalendarBounceAnimationDuration/4;
        group.duration = LKCalendarBounceAnimationDuration;
        group.animations = @[zoomOut, zoomIn];
        [self.bgLayer addAnimation:group forKey:@"bounce"];
    }
    
    self.bgLayer.opacity = selected ? 1.0 : 0.0;
}

#pragma mark - public methods
- (void)configureCell {
    self.eventLayer.opacity = self.hasEvent;
    self.bgLayer.fillColor = self.selectedDayBackgroundColor.CGColor;
    self.textLabel.textColor = self.dayTextColor;
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

- (CAShapeLayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.fillColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        _bgLayer.opacity = 0;
    }
    
    return _bgLayer;
}

- (CAShapeLayer *)eventLayer {
    if (!_eventLayer) {
        _eventLayer = [CAShapeLayer layer];
        _eventLayer.fillColor = [[UIColor colorWithRed:1 green:78.0 / 255.0 blue:0 alpha:1] CGColor];
        _eventLayer.opacity = 0;
    }
    
    return _eventLayer;
}

@end
