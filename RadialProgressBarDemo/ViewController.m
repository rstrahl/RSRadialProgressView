//
//  ViewController.m
//  RadialProgressBarDemo
//
//  Created by Rudi Strahl on 2014-03-12.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import "ViewController.h"
#import "RSRadialProgressView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet RSRadialProgressView *radialProgressView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *unitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;
- (IBAction)didChangeValueForUnitSwitch:(id)sender;
- (IBAction)didChangeValueForAnimateSwitch:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.radialProgressView.progress = 0.0f;
    self.progressSlider.minimumValue = 0.0f;
    self.progressSlider.maximumValue = 25.0f;
    self.progressSlider.value = 12.5f;
    self.progressSlider.continuous = YES;
    self.radialProgressView.progressLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    self.unitSwitch.on = (self.radialProgressView.style == RSRadialProgressViewStyleValue);
    self.animateSwitch.on = NO;
    [self updateRadialProgressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateRadialProgressView
{
    float progressValue = (self.progressSlider.value / self.progressSlider.maximumValue);
    NSString *progressText = [NSString stringWithFormat:@"%.0f", self.progressSlider.value];
    [self.radialProgressView setProgress:progressValue valueText:progressText animated:!self.progressSlider.continuous];
}

#pragma mark - IBActions

- (IBAction)didChangeValueForProgressSlider:(id)sender
{
    [self updateRadialProgressView];
}

- (IBAction)didChangeValueForUnitSwitch:(id)sender
{
    UISwitch *aSwitch = (UISwitch *)sender;
    _radialProgressView.style = (aSwitch.on) ? RSRadialProgressViewStyleValue : RSRadialProgressViewStylePercent;
    [self updateRadialProgressView];
}

- (IBAction)didChangeValueForAnimateSwitch:(id)sender
{
    UISwitch *aSwitch = (UISwitch *)sender;
    _progressSlider.continuous = !aSwitch.on;
    [self updateRadialProgressView];
}

@end
