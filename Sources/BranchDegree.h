//
//  BranchDegree.h
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 5. 25..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

#ifndef BranchDegree_h
#define BranchDegree_h


#define NORMAL_Y_FOV 38.35 // (42.1875 / 1.1); // Calculated by xfov(360/5 degree) and 16/9 ratio
#define BRANCH_PORTRAIT_Y_FOV 110 // 85
#define BRANCH_LANDSCAPE_Y_FOV 50


#define WIDTH 1280
#define HEIGHT 720
#define RADIUS 100.0

#define SCENE_WIDTH (3 * WIDTH)
#define SCENE_HEIGHT (HEIGHT)
#define NODE_WIDTH_DIVIDOR 5

static int tubeHeight = (2 * M_PI * RADIUS / 5.0) * (9.0 / 16.0);

static int nodeWidth = SCENE_WIDTH / NODE_WIDTH_DIVIDOR;
static int nodeHeight = HEIGHT;

static int nodeCenterX = SCENE_WIDTH / 2;
static int nodeCenterY = SCENE_HEIGHT / 2;


#endif /* BranchDegree_h */
