//
//  NYT360PlayerScene.m
//  NYT360Video
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import SpriteKit;
@import AVFoundation;

#import "NYT360PlayerScene.h"
#import "Branch.h"
#import "BranchDegree.h"


@class NYTSKVideoNode;

///-----------------------------------------------------------------------------
/// NYTSKVideoNodeDelegate
///-----------------------------------------------------------------------------

@protocol NYTSKVideoNodeDelegate <NSObject>

- (BOOL)videoNodeShouldAllowPlaybackToBegin:(NYTSKVideoNode *)videoNode;

@end

///-----------------------------------------------------------------------------
/// NYTSKVideoNode
///-----------------------------------------------------------------------------

/**
 *  There is a bug in SceneKit wherein a paused video node will begin playing again when the application becomes active. This is caused by cascading calls to `[fooNode setPaused:NO]` across all nodes in a scene. To prevent the video node from unpausing along with the rest of the nodes, we must subclass SKVideoNode and override `setPaused:`, only unpausing the node if `nytDelegate` allows it.
 *
 *  This SceneKit bug is present on iOS 9 as well as iOS 10 (at least up to beta 7, the latest at the time of this writing).
 */
@interface NYTSKVideoNode: SKVideoNode

/**
 *  The node's custom delegate. It's prefixed with `nyt_` to avoid any future conflicts with SKVideoNode properties, since this class may not be intended for subclassing.
 */
@property (nonatomic, weak) id<NYTSKVideoNodeDelegate> nyt_delegate;

@end

@implementation NYTSKVideoNode

- (void)setPaused:(BOOL)paused {
    if (!paused && self.nyt_delegate != nil) {
        if ([self.nyt_delegate videoNodeShouldAllowPlaybackToBegin:self]) {
            [super setPaused:NO];
        }
    } else {
        [super setPaused:paused];
    }
}
@end

///-----------------------------------------------------------------------------
/// NYT360PlayerScene
///-----------------------------------------------------------------------------

@interface NYT360PlayerScene () <NYTSKVideoNodeDelegate>

@property (nonatomic, assign) BOOL videoPlaybackIsPaused;
@property (nonatomic, readonly) SCNNode *screenNode;
@property (nonatomic, readonly) SKScene *skScene;
@property (nonatomic, readonly) SCNNode *cameraNode;
@property (nonatomic, readonly) NYTSKVideoNode *videoNode;
@property (nonatomic, readonly) AVPlayer *player;
@property (nonatomic, strong) NSMutableArray *branches;

- (Branch *)getBranch:(int)degree;

@end

@implementation NYT360PlayerScene

- (instancetype)initWithAVPlayer:(AVPlayer *)player boundToView:(SCNView *)view {
    if ((self = [super init])) {
        
        NSLog(@"%i", tubeHeight);
        
        _videoPlaybackIsPaused = YES;
        
        _player = player;
        _branches = [[NSMutableArray alloc] init];
        
        _camera = [SCNCamera new];
        //_camera.wantsHDR = YES;
        _camera.automaticallyAdjustsZRange = YES;
        
        _cameraNode = ({
            SCNNode *cameraNode = [SCNNode new];
            cameraNode.camera = _camera;
            cameraNode.position = SCNVector3Make(0, 0, 0);
            cameraNode;
        });
        [self.rootNode addChildNode:_cameraNode];
        
        _skScene = ({
            SKScene *scene = [[SKScene alloc] initWithSize:CGSizeMake(SCENE_WIDTH, SCENE_HEIGHT)];
            scene.shouldRasterize = YES;
            scene.scaleMode = SKSceneScaleModeAspectFit;
            
            _videoNode = ({
                NYTSKVideoNode *videoNode = [[NYTSKVideoNode alloc] initWithAVPlayer:player];
                NSLog(@"%f, %f", scene.size.width, scene.size.height);
                videoNode.size = CGSizeMake(nodeWidth, nodeHeight); // 28mm == 75 degree ~= 360/5 degree
                videoNode.position = CGPointMake(nodeCenterX, nodeCenterY);
                videoNode.yScale = -1;
                videoNode.xScale = 1;
                videoNode.nyt_delegate = self;
                videoNode;
            });
            [scene addChild:_videoNode];
            
            scene;
        });
        
        _screenNode = ({
            SCNNode *node = [SCNNode new];
            node.position = SCNVector3Make(0, 0, 0);
            node.geometry = [SCNTube tubeWithInnerRadius:RADIUS outerRadius:(RADIUS + 0.1) height:tubeHeight];
            //sphereNode.geometry = [SCNTube tubeWithInnerRadius:tubeRadius outerRadius:(tubeRadius + 0.1) height:74.25 / 2];
            //node.geometry = [SCNSphere sphereWithRadius:100.0]; //TODO [DZ]: What is the correct size here?
            node.geometry.firstMaterial.diffuse.contents = _skScene;
            node.geometry.firstMaterial.diffuse.minificationFilter = SCNFilterModeLinear;
            node.geometry.firstMaterial.diffuse.magnificationFilter = SCNFilterModeLinear;
            node.geometry.firstMaterial.doubleSided = NO;
            
            //NSLog(@"GeoCount: %d", node.geometry.geometryElementCount);
            
            node;
        });
        [self.rootNode addChildNode:_screenNode];
        
        
        view.scene = self;
        view.pointOfView = self.cameraNode;
        
        NSLog(@"%f, %f", self.cameraNode.camera.xFov, self.cameraNode.camera.yFov);
    }
    
    return self;
}

#pragma mark - Playback

- (void)play {
    
    // See note in NYTSKVideoNode above.
    self.videoPlaybackIsPaused = NO;
    
    if ([self.class isIOS10OrLater]) {
        [self.player play];
        self.videoNode.paused = NO;
    } else {
        self.videoNode.paused = NO;
    }
    
}

- (void)pause {
    // See note in NYTSKVideoNode above.
    self.videoPlaybackIsPaused = YES;
    
    if ([self.class isIOS10OrLater]) {
        [self.player pause];
        self.videoNode.paused = YES;
    } else {
        [self.player pause];
        self.videoNode.paused = YES;
    }
    
}

- (void)addNode:(NSString*)urlString degree:(int)degree {
    [self pause];

    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage* thumbnail = [UIImage imageWithData:imageData];
    int nodeX = 0;
    if (degree < 180) {
        nodeX = nodeWidth * (degree / 90.0);
    } else {
        nodeX = nodeWidth * ((180 - degree) / 90.0);
    }
    
    
    SKNode *branchNode = ({
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:thumbnail]];
        node.size = CGSizeMake(nodeWidth, nodeHeight);
        node.position = CGPointMake(nodeCenterX + nodeX, nodeCenterY);
        node.yScale = -1;
        node.xScale = 1;
        node;
    });
    [_skScene addChild:branchNode];
    
    Branch *branch = [[Branch alloc] initWithSKNode:branchNode thumbnail:urlString degree:degree];
    [self.branches addObject:branch];
}

- (void)replaceVideo:(NSString*)videoUrl degree:(int)degree {
    Branch *branch = [self getBranch:degree];
    branch.node.position = CGPointMake(nodeCenterX, nodeCenterY);
    

    NSMutableArray *removeNodes = [[NSMutableArray alloc] init];
    if (_videoNode != nil) { [removeNodes addObject: _videoNode]; }
    for (Branch* branch in self.branches) {
        if (branch.degree == degree) {
            continue;
        }
        [removeNodes addObject: branch.node];
    }

    [_skScene removeChildrenInArray:removeNodes];
    [self.branches removeAllObjects];
    

    NSURL * const url = [[NSURL alloc] initWithString:videoUrl];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:item];
    
    _videoNode = ({
        NYTSKVideoNode *videoNode = [[NYTSKVideoNode alloc] initWithAVPlayer:_player];
        videoNode.size = CGSizeMake(nodeWidth, nodeHeight); // 28mm == 75 degree ~= 360/5 degree
        videoNode.position = CGPointMake(nodeCenterX, nodeCenterY);
        videoNode.yScale = -1;
        videoNode.xScale = 1;
        videoNode.nyt_delegate = self;
        videoNode;
    });
    [_skScene addChild:_videoNode];
    NSLog(@"replaceVideo end");
}

- (void)removeBranchNodes {
    NSMutableArray *removeNodes = [[NSMutableArray alloc] init];
    for (Branch* branch in self.branches) {
        [removeNodes addObject: branch.node];
    }
    
    [_skScene removeChildrenInArray:removeNodes];
    [self.branches removeAllObjects];
}

- (Branch *)getBranch:(int)degree {
    for (Branch* branch in self.branches) {
        if (branch.degree == degree) {
            return branch;
        }
    }
    
    return nil;
}


#pragma mark - NYTSKVideoNodeDelegate

- (BOOL)videoNodeShouldAllowPlaybackToBegin:(NYTSKVideoNode *)videoNode {
    // See note in NYTSKVideoNode above.
    return !self.videoPlaybackIsPaused;
}

#pragma mark - Convenience

+ (BOOL)isIOS10OrLater {
    static BOOL isIOS10OrLater;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSOperatingSystemVersion ios10;
        ios10.majorVersion = 10;
        ios10.minorVersion = 0;
        ios10.patchVersion = 0;

        isIOS10OrLater = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios10];
    });

    return isIOS10OrLater;
}

@end
