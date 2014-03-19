//
//  RSRadialProgressView.h
//  RadialProgressBarDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RSRadialProgressViewStyle)
{
    RSRadialProgressViewStylePercent,
    RSRadialProgressViewStyleValue
};

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees) / 180)

@interface RSRadialProgressView : UIView

@property (strong, nonatomic) CAShapeLayer *trackLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) CAShapeLayer *checkmarkLayer;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *percentLabel;
@property (strong, nonatomic) UILabel *unitsLabel;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIColor *progressTintColor;
@property (strong, nonatomic) UIColor *trackTintColor;
@property (strong, nonatomic) UIView *labelsView;
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) BOOL clockwise;
@property (assign, nonatomic) BOOL displaysCompletionCheckmark;
@property (assign, nonatomic) CGFloat startAngle;
@property (assign, nonatomic) CGFloat trackLineWidth;
@property (assign, nonatomic) CGFloat progressLineWidth;
@property (assign, nonatomic) CGFloat checkmarkLineWidth;
@property (assign, nonatomic) RSRadialProgressViewStyle style;

- (void)setProgress:(float)progress animated:(BOOL)animated;
- (void)setProgress:(float)progress valueText:(NSString *)text animated:(BOOL)animated;

@end
