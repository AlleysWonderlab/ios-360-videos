//
//  Poi.m
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 7. 21..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@implementation Poi

@synthesize node;
@synthesize degree;

- (id)initWithSKNode:(SKNode *)aNode
              degree:(int)aDegree
{
    if( self = [super init] )
    {
        node = aNode;
        degree = aDegree;
    }
    
    return self;
}

@end
