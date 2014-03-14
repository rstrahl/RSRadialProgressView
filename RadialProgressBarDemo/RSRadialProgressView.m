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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
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
    _startAngle = 270;
    _progress = 0;
    _progressTintColor = self.trackTintColor = self.progressLabelTintColor = self.unitLabelTintColor = [UIColor blackColor];
    
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
    NSLayoutConstraint *centerProgressX = [NSLayoutConstraint constraintWithItem:_progressLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_labelsView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *centerProgressY = [NSLayoutConstraint constraintWithItem:_progressLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_labelsView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0];
    [_labelsView addConstraint:centerProgressX];
    [_labelsView addConstraint:centerProgressY];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    
    // Draw track
    CGFloat trackRadius = (self.frame.size.width - 2*kTrackLineWidth) / 2;
    CGPoint centerPointInView = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat trackEndAngle = _startAngle + 360;
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                             radius:trackRadius
                                                         startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                           endAngle:DEGREES_TO_RADIANS(trackEndAngle)
                                                          clockwise:self.clockwise];
    CGContextSetStrokeColorWithColor(context, [_trackTintColor CGColor]);
    [trackPath setLineWidth:kTrackLineWidth];
    [trackPath stroke];

    // Draw progress
    CGFloat progressRadius = (self.frame.size.width - 2*kProgressLineWidth + 1) / 2;
    CGFloat progressEndAngle = _startAngle + (360 * _progress);
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:centerPointInView
                                                             radius:progressRadius
                                                         startAngle:DEGREES_TO_RADIANS(_startAngle)
                                                           endAngle:DEGREES_TO_RADIANS(progressEndAngle)
                                                          clockwise:self.clockwise];
    CGContextSetStrokeColorWithColor(context, [_trackTintColor CGColor]);
    [progressPath setLineWidth:kProgressLineWidth];
    [progressPath stroke];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_progressLabel sizeToFit];
}

#pragma mark - Property Overrides

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    _progressLabel.text = [NSString stringWithFormat:@"%.2d", (int)(_progress * 100)];
    [self setNeedsDisplay];
}

@end
