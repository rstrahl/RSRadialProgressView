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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.radialProgressView.progress = 0.0f;
    self.progressSlider.minimumValue = 0.0f;
    self.progressSlider.maximumValue = 1.0f;
    self.progressSlider.continuous = YES;
    [self.radialProgressView setProgress:self.progressSlider.value];
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
    [self.radialProgressView setProgress:progressValue];
}

@end
