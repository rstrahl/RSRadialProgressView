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
    
}

#pragma mark - Property Overrides

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
