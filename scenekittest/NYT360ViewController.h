//
//  NYT360ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

@import UIKit;
@import SceneKit;

@class AVPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface NYT360ViewController : UIViewController <SCNSceneRendererDelegate>

@property (nonatomic, null_unspecified) AVPlayer *player;

@end

NS_ASSUME_NONNULL_END
