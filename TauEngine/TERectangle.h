//
//  TERectangle.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEPolygon.h"

typedef enum {
  kTERectangleBottomRight = 0,
  kTERectangleTopRight    = 1,
  kTERectangleTopLeft     = 2,
  kTERectangleBottomLeft  = 3,
} TERectangleCornerVertex;

@interface TERectangle : TEPolygon {
  GLfloat height, width;
}

@property GLfloat height, width;

@end
