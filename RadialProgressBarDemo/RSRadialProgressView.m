//
//  RSRadialProgressView.m
//  RadialProgressBarDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import "RSRadialProgressView.h"

@implementation RSRadialProgressView

static const CGFloat kTrackLineWidth = 1.0f;
static const CGFloat kProgressLineWidth = 4.0f;

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
    _startAngle = 270;
    _progress = 0;
    _progressTintColor = self.trackTintColor = [UIColor blackColor];
    
    // Add track/progress layers
    _trackLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_trackLayer];
    _progressLayer = [CAShapeLayer layer];
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
                                                                       multiplier:0.70
                                                                         constant:-kProgressLineWidth];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_labelsView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:0.70
                                                                         constant:-kProgressLineWidth];
    [self addConstraint:centerConstraintX];
    [self addConstraint:centerConstraintY];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
    
    // Add progress label
    _progressLabel = [[UILabel alloc] init];
    [_progressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progressLabel setAdjustsFontSizeToFitWidth:YES];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    [_labelsView addSubview:_progressLabel];
    [_labelsView addConstraint:[NSLayoutConstraint constraintWithItem:_progressLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_labelsView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0]];
    [_labelsView addConstraint:[NSLayoutConstraint constraintWithItem:_progressLabel
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_labelsView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:0]];
    
    // Add percentage symbol label
    _percentLabel = [[UILabel alloc] init];
    _percentLabel.text = @"%";
    [_percentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_percentLabel setAdjustsFontSizeToFitWidth:YES];
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
    [_unitsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_unitsLabel setAdjustsFontSizeToFitWidth:YES];
    [_unitsLabel setTextAlignment:NSTextAlignmentCenter];
    [_labelsView addSubview:_unitsLabel];
    [_labelsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_progressLabel]-0-[_unitsLabel]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_progressLabel, _unitsLabel)]];
    [_labelsView addConstraint:[NSLayoutConstraint constraintWithItem:_unitsLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_progressLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1
                                                             constant:0]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_progressLabel sizeToFit];
    [_unitsLabel sizeToFit];
    
    // Re-calculate the track path and update
    CGPoint centerPointInView = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat trackRadius = (self.frame.size.width - 2*kTrackLineWidth) / 2;
    CGFloat trackEndAngle = _startAngle + 360;
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                             radius:trackRadius
                                                         startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                           endAngle:DEGREES_TO_RADIANS(trackEndAngle)
                                                          clockwise:self.clockwise];
    _trackLayer.path = trackPath.CGPath;
    _progressLayer.path = trackPath.CGPath;
    
#warning CODE REVIEW - Refactor these into setter overrides, shouldn't belong here
    [_trackLayer setLineWidth:kTrackLineWidth];
    [_trackLayer setStrokeColor:[_trackTintColor CGColor]];
    [_trackLayer setFillColor:[[UIColor clearColor] CGColor]];
    [_progressLayer setLineWidth:kProgressLineWidth];
    [_progressLayer setStrokeColor:[_progressTintColor CGColor]];
    [_progressLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    [self updateLabels];
}

#pragma mark - UI Update/Drawing/Animation

- (void)updateLabels
{
    _percentLabel.hidden = (_style == RSRadialProgressViewStyleValue);
    _unitsLabel.hidden = (_style == RSRadialProgressViewStylePercent);
}

#pragma mark - Property Overrides

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
        _progressLabel.text = [NSString stringWithFormat:@"%.2d", (int)(progress * 100)];
    }
    else
    {
        _progressLabel.text = text;
    }
    _progress = progress;
}

- (void)setStyle:(RSRadialProgressViewStyle)style
{
    _style = style;
    [self updateLabels];
}

@end
