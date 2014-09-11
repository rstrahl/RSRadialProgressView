//
//  RSRadialProgressView.m
//  RadialProgressViewDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

CGFloat const kStartAngle           = 270.0f;   //< Starting angle is at "12-oclock"

#import "RSRadialProgressView.h"

@implementation RSRadialProgressView

CGSize maximumLabelRectSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults
{
    _clockwise = YES;
    self.progressStartAngle = kStartAngle;
    
    _baseLineWidth = 0;
    _baseLayer = [CAShapeLayer layer];
    [_baseLayer setLineWidth:_baseLineWidth];
    [_baseLayer setStrokeColor:[self.tintColor CGColor]];
    [_baseLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.layer addSublayer:_baseLayer];
    
    _progressLineWidth = (self.frame.size.width / 2);
    _progressLayer = [CAShapeLayer layer];
    [_progressLayer setLineWidth:_progressLineWidth];
    [_progressLayer setStrokeColor:[_progressTintColor CGColor]];
    [_progressLayer setFillColor:[_progressTintColor CGColor]];
    [self.layer addSublayer:_progressLayer];
}

#pragma mark - UI Update/Drawing/Animation

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint centerPointInView = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat baseRadius = (self.frame.size.width / 2);
    CGFloat baseEndAngle = self.progressStartAngle + 360;
    UIBezierPath *basePath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                            radius:baseRadius
                                                        startAngle:DEGREES_TO_RADIANS(self.progressStartAngle)
                                                          endAngle:DEGREES_TO_RADIANS(baseEndAngle)
                                                         clockwise:self.clockwise];
    _baseLayer.path = basePath.CGPath;
    
    CGFloat progressRadius = ((self.frame.size.width - _progressLineWidth) / 2);
    CGFloat progressEndAngle = self.progressStartAngle + 360;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                                radius:progressRadius
                                                            startAngle:DEGREES_TO_RADIANS(self.progressStartAngle)
                                                              endAngle:DEGREES_TO_RADIANS(progressEndAngle)
                                                             clockwise:self.clockwise];
    _progressLayer.path = progressPath.CGPath;
}

#pragma mark - Property Overrides

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    [_progressLayer setStrokeColor:[_progressTintColor CGColor]];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [_baseLayer setFillColor:[self.tintColor CGColor]];
    [_baseLayer setStrokeColor:[_progressTintColor CGColor]];
}

- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    [_progressLayer setLineWidth:_progressLineWidth];
    [self setNeedsLayout];
}

- (void)setBaseLineWidth:(CGFloat)baseLineWidth
{
    _baseLineWidth = baseLineWidth;
    [_baseLayer setLineWidth:_baseLineWidth];
    [self setNeedsLayout];
}

- (void)setProgressStartAngle:(CGFloat)progressStartAngle
{
    _progressStartAngle = progressStartAngle;
    [self setNeedsLayout];
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:YES];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (animated)
    {
        [_progressLayer setValue:@(progress) forKeyPath:@"strokeEnd"];
    }
    else
    {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [_progressLayer setValue:@(progress) forKeyPath:@"strokeEnd"];
        [CATransaction commit];
    }
    _progress = progress;
}

@end
