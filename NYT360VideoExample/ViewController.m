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
@property (nonatomic) NYT360ViewController *nyt360VC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Create an AVPlayer for a 360º video:
    //NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://dwknz3zfy9iu1.cloudfront.net/uscenes_h-264_hd_test.mp4"]; // 1080
    NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]; // 720
    //NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/U3/pSuGmKWGOwSiFwEOTV_g-ivv.mp4"]
    self.player = [[AVPlayer alloc] initWithURL:videoURL];

    // Create a NYT360ViewController with the AVPlayer and our app's motion manager:
    id<NYT360MotionManagement> const manager = [NYT360MotionManager sharedManager];
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player motionManager:manager];

    // Embed the player view controller in our UI, via view controller containment:
    [self addChildViewController:self.nyt360VC];
    [self.view addSubview:self.nyt360VC.view];
    [self.nyt360VC didMoveToParentViewController:self];

    // Begin playing the 360º video:
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

    // In this example, tapping the video will place the horizon in the middle of the screen:
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reorientVerticalCameraAngle:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)reorientVerticalCameraAngle:(id)sender {
    [self.nyt360VC reorientVerticalCameraAngleToHorizon:YES];
}

- (void)itemDidFinishPlaying:(NSNotification *) notification {
    NSLog(@"itemDidFinishPlaying");
    [self.player seekToTime:CMTimeMake(0.0, 1.0)];
    [self.player play];
}

@end
