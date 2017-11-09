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
@property (nonatomic, strong) UIView *eventContainerView;

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
    [self.contentView addSubview:self.eventContainerView];
    [self.contentView.layer addSublayer:self.bgLayer];
    [self.contentView addSubview:self.textLabel];
    [self.contentView.layer addSublayer:self.eventLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    self.bgLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - 30) / 2, (CGRectGetHeight(self.bounds) - 30) / 2, 30, 30);
    self.eventLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - 5) / 2, CGRectGetMaxY(self.bgLayer.frame) - 2.5, 5, 5);
    self.eventContainerView.frame = CGRectMake((CGRectGetWidth(self.bounds) - 34) / 2, (CGRectGetHeight(self.bounds) - 34) / 2, 34, 34);
    self.eventView.frame = self.eventContainerView.bounds;
    
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
    self.textLabel.font = self.dayTextFont;
}

- (void)setEventView:(UIView *)eventView {
    _eventView = eventView;
    [self.eventContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (eventView) {
        [self.eventContainerView addSubview:eventView];
        [self setNeedsLayout];
    }
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

- (UIView *)eventContainerView {
    if (!_eventContainerView) {
        _eventContainerView = [UIView new];
    }
    
    return _eventContainerView;
}

@end

