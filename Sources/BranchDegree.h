//
//  BranchDegree.h
//  ios-360-videos
//
//  Created by laeyoung.chang on 2017. 5. 25..
//  Copyright © 2017년 The New York Times Company. All rights reserved.
//

#ifndef BranchDegree_h
#define BranchDegree_h


#define NORMAL_Y_FOV 47 // (52.7343 / 1.1); // Calculated by xfov(360/4 degree) and 16/9 ratio
#define MIN_Y_FOV 35
#define MAX_PORTRAIT_Y_FOV 121
//#define MAX_PORTRAIT_Y_FOV 121
#define MAX_LANDSCAPE_Y_FOV 58

#define BRANCH_PORTRAIT_Y_FOV 125 // 85
#define BRANCH_LANDSCAPE_Y_FOV 65

#define MAX_MINIMAP_Y_FOV 75 //75 //80 // 70 //60 //85


#define NODE_WIDTH_DIVIDOR 4.0

#define FOV_ANIMATION_DURATION 0.7

//#define NORMAL_Y_FOV 38.35 // (42.1875 / 1.1); // Calculated by xfov(360/5 degree) and 16/9 ratio
//#define BRANCH_PORTRAIT_Y_FOV 110 // 85
//#define BRANCH_LANDSCAPE_Y_FOV 50
//#define NODE_WIDTH_DIVIDOR 5.0


#define WIDTH 1280
#define HEIGHT 720
#define RADIUS 100.0

#define SCENE_WIDTH (3 * WIDTH)
#define SCENE_HEIGHT (HEIGHT)


static int tubeHeight = (2 * M_PI * RADIUS / NODE_WIDTH_DIVIDOR) * (9.0 / 16.0);

static int nodeWidth = SCENE_WIDTH / NODE_WIDTH_DIVIDOR;
static int nodeHeight = HEIGHT;

static int nodeCenterX = SCENE_WIDTH / 2;
static int nodeCenterY = SCENE_HEIGHT / 2;

static int poiWidth = 80;
static int poiHeight = 80;


#endif /* BranchDegree_h */
