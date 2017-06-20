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
@property (nonatomic) double startFov;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Create an AVPlayer for a 360º video:
    //NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://dwknz3zfy9iu1.cloudfront.net/uscenes_h-264_hd_test.mp4"]; // 1080
    NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]; // 720
    //NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/U3/pSuGmKWGOwSiFwEOTV_g-ivv.mp4"];
    //NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/U3/pSuGmKWGOwSiFwEOTV_g-navi.mp4"];
    self.player = [[AVPlayer alloc] initWithURL:videoURL];
    
    

    // Create a NYT360ViewController with the AVPlayer and our app's motion manager:
    id<NYT360MotionManagement> const manager = [NYT360MotionManager sharedManager];
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player motionManager:manager];
    
    
    self.nyt360VC.delegate = self;
    

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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(addRightNode:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Add Node" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 100.0, 160.0, 40.0);
    [self.view addSubview:button];
    
    UIButton *branchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [branchButton addTarget:self
               action:@selector(branch:)
     forControlEvents:UIControlEventTouchUpInside];
    [branchButton setTitle:@"Branch" forState:UIControlStateNormal];
    branchButton.frame = CGRectMake(80.0, 150.0, 160.0, 40.0);
    [self.view addSubview:branchButton];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton addTarget:self
                   action:@selector(play:)
         forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    playButton.frame = CGRectMake(80.0, 200.0, 160.0, 40.0);
    [self.view addSubview:playButton];
}

- (void)reorientVerticalCameraAngle:(id)sender {
    [self.nyt360VC reorientVerticalCameraAngleToHorizon:YES];
}

- (void)itemDidFinishPlaying:(NSNotification *) notification {
    NSLog(@"itemDidFinishPlaying");
    [self.player seekToTime:CMTimeMake(0.0, 1.0)];
    [self.player play];
}

- (IBAction)addRightNode:(id)sender {
    [self.nyt360VC addNode:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/wR/TrthhhIEd02eQjV_GX4g-s.jpg" degree:270];
    [self.nyt360VC addNode:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/pP/zJQAQmoGi7D1hQVI9khQ.jpg" degree:90];
    
    [self.nyt360VC setCameraFOVWithAnimation:180];
}

- (IBAction)branch:(id)sender {
    [self.nyt360VC selectBranch:@"https://v-2-alleys-co.s3.dualstack.ap-northeast-1.amazonaws.com/pP/zJQAQmoGi7D1hQVI9khQ-ivv.mp4"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (IBAction)play:(id)sender {
    [self.nyt360VC play];
}


- (IBAction)pinchZoom:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.startFov = [self.nyt360VC getCameraFOV];
        //NSLog(@"PinchZoom Begin: %f", recognizer.scale);
    }
    
    //NSLog(@"PinchZoom: %f", recognizer.scale);
    [self.nyt360VC setCameraFOV:self.startFov / recognizer.scale];
}


#pragma mark - NYT360ViewControllerDelegate
- (void)nyt360ViewController:(NYT360ViewController *)viewController didUpdateCompassAngle:(float)compassAngle {
    //NSLog(@"didUpdateCompassAngle %f", -compassAngle);
}

- (void)videoViewController:(NYT360ViewController *)viewController userInitallyMovedCameraViaMethod:(NYT360UserInteractionMethod)method {
    NSLog(@"userInitallyMovedCameraViaMethod");
}

- (void)focusChanged:(int)degree {
    NSLog(@"focusedNode %d", degree);
}

@end
