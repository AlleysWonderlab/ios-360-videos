//
//  ViewController.m
//  NYT360VideoExample
//
//  Created by Chris Dzombak on 7/25/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import AVFoundation;
@import NYT360Video;

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayer *player2;
@property (nonatomic) NYT360ViewController *nyt360VC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Create an AVPlayer for a 360º video:
    NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/U3/pSuGmKWGOwSiFwEOTV_g-ivv.mp4"];
    self.player = [[AVPlayer alloc] initWithURL:videoURL];
    
    NSURL * const videoURL2 = [[NSURL alloc] initWithString:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/Rp/Xk7odPXKAJtiUerhfC0w-ivv.mp4"];
    self.player2 = [[AVPlayer alloc] initWithURL:videoURL2];

    // Create a NYT360ViewController with the AVPlayer and our app's motion manager:
    id<NYT360MotionManagement> const manager = [NYT360MotionManager sharedManager];
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player player2:self.player2 motionManager:manager];

    // Embed the player view controller in our UI, via view controller containment:
    [self addChildViewController:self.nyt360VC];
    [self.view addSubview:self.nyt360VC.view];
    [self.nyt360VC didMoveToParentViewController:self];

    // Begin playing the 360º video:
    [self.player play];

    // In this example, tapping the video will place the horizon in the middle of the screen:
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reorientVerticalCameraAngle:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)reorientVerticalCameraAngle:(id)sender {
    [self.nyt360VC reorientVerticalCameraAngleToHorizon:YES];
}

@end
