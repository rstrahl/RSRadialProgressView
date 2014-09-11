//
//  ViewController.m
//  RadialProgressViewDemo
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
@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;

- (IBAction)didChangeValueForAnimateSwitch:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressSlider.minimumValue = 0.0f;
    self.progressSlider.maximumValue = 25.0f;
    self.progressSlider.value = 12.5f;
    
    self.radialProgressView.progress = 0.0f;
    self.radialProgressView.progressTintColor = [UIColor colorWithRed:54.0/255.0 green:137.0/255.0 blue:255/255 alpha:1.0f];
    self.radialProgressView.tintColor = [UIColor lightGrayColor];
    
    [self.animateSwitch setOn:YES];
    [self didChangeValueForAnimateSwitch:self.animateSwitch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didChangeValueForProgressSlider:(id)sender
{
    float progressValue = (self.progressSlider.value / self.progressSlider.maximumValue);
    [self.radialProgressView setProgress:progressValue animated:self.animateSwitch.on];
}

- (IBAction)didChangeValueForAnimateSwitch:(id)sender
{
    UISwitch *aSwitch = (UISwitch *)sender;
    _progressSlider.continuous = !aSwitch.on;
    _instructionLabel.text = (_progressSlider.continuous) ? @"Drag Slider Continually" : @"Drag and Release Slider";
}

@end
