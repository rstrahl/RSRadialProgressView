//
//  RSRadialProgressView.h
//  RadialProgressViewDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees) / 180)
#endif

/**
 * A view that presents a circular, pie-style display that provides two regions; filled
 * and un-filled. As the progress property is set, the view will adjust the size of the
 * filled region. Default behaviour is to animate the adjustment of the filled region,
 * use the setProgress:animated: method to indicate NO if the adjustment should not animate.
 *
 * The UIView tint property sets the color for the unfilled region; use the progressTintColor
 * property to change the filled region color.
 */
@interface RSRadialProgressView : UIView

/** The background layer of the progress view */
@property (strong, nonatomic) CAShapeLayer *baseLayer;
/** The progress layer of the progress view */
@property (strong, nonatomic) CAShapeLayer *progressLayer;
/** The color used to fill the progress layer */
@property (strong, nonatomic) UIColor *progressTintColor;
/** The progress-to-completion for the progress layer */
@property (assign, nonatomic) float progress;
/** Display the progress completion in clockwise fashion or counter-clockwise */
@property (assign, nonatomic) BOOL clockwise;
/** The thickness of the progress (defaults to fill) */
@property (assign, nonatomic) CGFloat progressLineWidth;
/** The outer stroke thickness of the pie view */
@property (assign, nonatomic) CGFloat baseLineWidth;
/** The angle (in degrees) where the progress layer begins its drawing */
@property (assign, nonatomic) CGFloat progressStartAngle;

/**
 *  Sets the progress value for the view.
 *
 *  @param progress a float value between 0..1
 *  @param animated YES if the progress layer should update to the new value with an animation, NO otherwise
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
