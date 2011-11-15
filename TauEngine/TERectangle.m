//
//  TERectangle.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TERectangle.h"

@implementation TERectangle

- (id)init
{
  self = [super initWithVertices:4];
  if (self) {
    width = height = 1.0;
    [self updateVertices];
  }
  
  return self;
}

-(void)updateVertices {
  self.vertices[kTERectangleBottomRight] = GLKVector2Make( width/2.0, -height/2.0);
  self.vertices[kTERectangleTopRight]    = GLKVector2Make( width/2.0,  height/2.0);
  self.vertices[kTERectangleTopLeft]     = GLKVector2Make(-width/2.0,  height/2.0);
  self.vertices[kTERectangleBottomLeft]  = GLKVector2Make(-width/2.0, -height/2.0);
}

-(GLfloat)height {
  return height;
}

-(void)setHeight:(GLfloat)_height {
  height = _height;
  [self updateVertices];
}

-(GLfloat)width {
  return width;
}

-(void)setWidth:(GLfloat)_width {
  width = _width;
  [self updateVertices];
}

@end
