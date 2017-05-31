//
//  BranchNode.h
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 5. 31..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

@import SpriteKit;

@interface Branch:NSObject
{
    SKNode *node;
    NSString *thumbnail;
    int degree;
}
@property(nonatomic, readwrite) SKNode *node;
@property(nonatomic, readwrite) NSString *thumbnail;
@property(nonatomic, readwrite) int degree;

- (id)initWithSKNode:(SKNode *)aNode
               thumbnail:(NSString *)aThumbnail
                 degree:(int)aDegree;

@end
