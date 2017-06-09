//
//  BranchNode.h
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 5. 31..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

@import SpriteKit;

@interface Branch:NSObject

@property(nonatomic, assign) SKNode *node;
@property(nonatomic, assign) NSString *thumbnail;
@property(nonatomic, assign) int degree;

- (id)initWithSKNode:(SKNode *)aNode
               thumbnail:(NSString *)aThumbnail
                 degree:(int)aDegree;

@end
