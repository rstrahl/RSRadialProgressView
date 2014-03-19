//
//  RSRadialProgressView.m
//  RadialProgressBarDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import "RSRadialProgressView.h"

@implementation RSRadialProgressView

CGSize maximumLabelRectSize;

- (id)initWithFrame:(CGRect)frame style:(RSRadialProgressViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _style = style;
        [self setupDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:RSRadialProgressViewStylePercent];
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
    _displaysCompletionCheckmark = NO;
    _startAngle = 270;
    _progress = 0;
    _progressTintColor = _trackTintColor = [UIColor blackColor];
    
    _trackLineWidth = 1.0f;
    _progressLineWidth = 4.0f;
    _checkmarkLineWidth = 4.0f;
    
    [self drawCompletionCheckmark];
    
    // Add track/progress layers
    _trackLayer = [CAShapeLayer layer];
    [_trackLayer setLineWidth:_trackLineWidth];
    [_trackLayer setStrokeColor:[_trackTintColor CGColor]];
    [_trackLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.layer addSublayer:_trackLayer];
    _progressLayer = [CAShapeLayer layer];
    [_progressLayer setLineWidth:_progressLineWidth];
    [_progressLayer setStrokeColor:[_progressTintColor CGColor]];
    [_progressLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.layer addSublayer:_progressLayer];
    
    // Add label container
    _labelsView = [[UIView alloc] init];
    [_labelsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_labelsView];
    NSLayoutConstraint *centerConstraintX = [NSLayoutConstraint constraintWithItem:_labelsView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1
                                                                         constant:0];
    NSLayoutConstraint *centerConstraintY = [NSLayoutConstraint constraintWithItem:_labelsView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_labelsView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_labelsView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:0];
    [self addConstraint:centerConstraintX];
    [self addConstraint:centerConstraintY];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
    
    // Add progress label
    _progressLabel = [[UILabel alloc] init];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    [_labelsView addSubview:_progressLabel];
    
    // Add percentage symbol label
    _percentLabel = [[UILabel alloc] init];
    _percentLabel.text = @"%";
    [_percentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_percentLabel setTextAlignment:NSTextAlignmentCenter];
    [_labelsView addSubview:_percentLabel];
    [_labelsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_progressLabel]-0-[_percentLabel]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_progressLabel, _percentLabel)]];
    [_labelsView addConstraint:[NSLayoutConstraint constraintWithItem:_percentLabel
                                                            attribute:NSLayoutAttributeBaseline
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_progressLabel
                                                            attribute:NSLayoutAttributeBaseline
                                                           multiplier:1
                                                             constant:0]];
    
    // Add units label
    _unitsLabel = [[UILabel alloc] init];
    _unitsLabel.text = @"UNITS";
    [_unitsLabel setTextAlignment:NSTextAlignmentCenter];
    [_labelsView addSubview:_unitsLabel];
}

#pragma mark - UI Update/Drawing/Animation

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutLabels];
    
    // Re-calculate the track/progress paths
    CGPoint centerPointInView = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat trackRadius = (self.frame.size.width - _trackLineWidth) / 2;
    CGFloat trackEndAngle = _startAngle + 360;
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                             radius:trackRadius
                                                         startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                           endAngle:DEGREES_TO_RADIANS(trackEndAngle)
                                                          clockwise:self.clockwise];
    _trackLayer.path = trackPath.CGPath;

    CGFloat progressRadius = (self.frame.size.width - _progressLineWidth) / 2;
    CGFloat progressEndAngle = _startAngle + 360;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                                radius:progressRadius
                                                            startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                              endAngle:DEGREES_TO_RADIANS(progressEndAngle)
                                                             clockwise:self.clockwise];
    _progressLayer.path = progressPath.CGPath;
    [self updateLabels];
}

- (void)layoutLabels
{
    [_percentLabel sizeToFit];
    [self layoutProgressLabel];
    [self layoutUnitsLabel];
}

- (void)layoutProgressLabel
{
    // Progress Label
    [_progressLabel sizeToFit];
    CGRect progressLabelFrame = _progressLabel.frame;
    progressLabelFrame.origin.x = (_progressLabel.superview.frame.size.width / 2) - (progressLabelFrame.size.width / 2);
    progressLabelFrame.origin.y = (_progressLabel.superview.frame.size.height / 2) - (progressLabelFrame.size.height / 2);
    _progressLabel.frame = progressLabelFrame;
}

- (void)layoutUnitsLabel
{
    // Units Label
    [_unitsLabel sizeToFit];
    CGRect unitsLabelFrame = _unitsLabel.frame;
    unitsLabelFrame.origin.x = (_unitsLabel.superview.frame.size.width / 2) - (unitsLabelFrame.size.width / 2);
    unitsLabelFrame.origin.y = (_progressLabel.frame.origin.y + _progressLabel.frame.size.height) + (_progressLabel.font.descender);
    _unitsLabel.frame = unitsLabelFrame;
}

- (void)updateLabels
{
    _percentLabel.hidden = (_style == RSRadialProgressViewStyleValue);
    _unitsLabel.hidden = (_style == RSRadialProgressViewStylePercent);
}

- (void)drawCompletionCheckmark
{
    _checkmarkLayer = [CAShapeLayer layer];
    UIBezierPath *checkmarkPath = [UIBezierPath bezierPath];
    
    _checkmarkLayer.lineWidth = _checkmarkLineWidth;
    _checkmarkLayer.fillColor = [[UIColor clearColor] CGColor];
    _checkmarkLayer.lineCap = kCALineCapRound;
    _checkmarkLayer.lineJoin = kCALineJoinRound;
    _checkmarkLayer.strokeColor = [_progressTintColor CGColor];
    
    [checkmarkPath moveToPoint:CGPointMake((self.frame.size.width * 0.3), (self.frame.size.height * 0.55))];
    [checkmarkPath addLineToPoint:CGPointMake((self.frame.size.width / 2), (self.frame.size.height * 0.75))];
    [checkmarkPath addLineToPoint:CGPointMake((self.frame.size.width * 0.65), (self.frame.size.height * 0.3))];
    
    _checkmarkLayer.path = [checkmarkPath CGPath];
    _checkmarkLayer.opacity = 0.0f;
    [self.layer addSublayer:_checkmarkLayer];
}

#pragma mark - Property Overrides

- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    [_progressLayer setLineWidth:_progressLineWidth];
}

- (void)setTrackLineWidth:(CGFloat)trackLineWidth
{
    _trackLineWidth = trackLineWidth;
    [_trackLayer setLineWidth:_trackLineWidth];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    [_progressLayer setStrokeColor:[_progressTintColor CGColor]];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    [_trackLayer setStrokeColor:[_trackTintColor CGColor]];
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    [self setProgress:progress valueText:nil animated:animated];
}

- (void)setProgress:(float)progress valueText:(NSString *)text animated:(BOOL)animated
{
    if (_displaysCompletionCheckmark)
    {
        _progressLabel.hidden = (BOOL)progress;
        [_checkmarkLayer setValue:@((BOOL)progress) forKey:@"opacity"];
    }
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
    
    if (_style == RSRadialProgressViewStylePercent)
    {
        _progressLabel.text = [NSString stringWithFormat:@"%d", (int)(progress * 100)];
        _percentLabel.hidden = (_displaysCompletionCheckmark) ? (BOOL)progress : NO;
    }
    else
    {
        _progressLabel.text = text;
        _unitsLabel.hidden = (_displaysCompletionCheckmark) ? (BOOL)progress : NO;
    }
    
    [self layoutProgressLabel];
    _progress = progress;
}

- (void)setStyle:(RSRadialProgressViewStyle)style
{
    _style = style;
    [self updateLabels];
}

@end
