//
//  Poi.h
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 7. 21..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

@import SpriteKit;

@interface Poi:NSObject

@property(nonatomic, assign) SKNode *node;
@property(nonatomic, assign) int degree;

- (id)initWithSKNode:(SKNode *)aNode
              degree:(int)aDegree;

@end
