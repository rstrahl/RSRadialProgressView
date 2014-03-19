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
    self.progressSlider.maximumValue = 1.0f;
    self.progressSlider.continuous = YES;
    [self.radialProgressView setProgress:self.progressSlider.value];
    self.radialProgressView.progressLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    self.unitSwitch.on = (self.radialProgressView.style == RSRadialProgressViewStyleValue);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didChangeValueForProgressSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float progressValue = slider.value;
    [self.radialProgressView setProgress:progressValue animated:!slider.continuous];
}

- (IBAction)didChangeValueForUnitSwitch:(id)sender
{
    UISwitch *aSwitch = (UISwitch *)sender;
    _radialProgressView.style = (aSwitch.on) ? RSRadialProgressViewStyleValue : RSRadialProgressViewStylePercent;
}

- (IBAction)didChangeValueForAnimateSwitch:(id)sender
{
    UISwitch *aSwitch = (UISwitch *)sender;
    _progressSlider.continuous = !aSwitch.on;
}

@end
