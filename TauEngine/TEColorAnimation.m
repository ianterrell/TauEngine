//
//  TEColorAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEColorAnimation.h"

@implementation TEColorAnimation

@synthesize color, previousColor;

-(id)initWithNode:(TENode *)_node
{
  self = [super initWithNode:_node];
  if (self) {
    self.color = _node.shape.color;
    self.previousColor = _node.shape.color;
  }
  
  return self;
}

-(GLKVector4)easedColor {
  return GLKVector4MultiplyScalar(GLKVector4Subtract(self.color, self.previousColor), self.easingFactor);
}

-(void)permanentize {
  self.node.shape.color = color;
}

@end
