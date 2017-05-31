//
//  Branch.m
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 5. 31..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Branch.h"

@implementation Branch

@synthesize node;
@synthesize thumbnail;
@synthesize degree;

- (id)initWithSKNode:(SKNode *)aNode
               thumbnail:(NSString *)aThumbnail
                 degree:(int)aDegree
{
    if( self = [super init] )
    {
        node = aNode;
        thumbnail = aThumbnail;
        degree = aDegree;
    }
    
    return self;
}

@end
