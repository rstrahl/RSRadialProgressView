//
//  RSRadialProgressView.h
//  RadialProgressBarDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RSRadialProgressViewStyleValue,
    RSRadialProgressViewStylePercent
} RSRadialProgressViewStyle;

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees) / 180)

@interface RSRadialProgressView : UIView

@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *unitsLabel;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIColor *progressLabelTintColor;
@property (strong, nonatomic) UIColor *unitLabelTintColor;
@property (strong, nonatomic) UIColor *progressTintColor;
@property (strong, nonatomic) UIColor *trackTintColor;
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) BOOL clockwise;
@property (assign, nonatomic) CGFloat startAngle;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
