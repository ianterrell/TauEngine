//
//  TEVertexColorAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/30/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEVertexColorAnimation.h"

@implementation TEVertexColorAnimation

@synthesize fromColorVertices, easedColorVertices;

-(id)initWithNode:(TENode *)_node
{
  self = [super initWithNode:_node];
  if (self) {
    numVertices = node.shape.numVertices;
    
    fromColorData = [node.shape colorData];
    fromColorVertices = [fromColorData mutableBytes];
    
    easedColorData = [fromColorData mutableCopy];
    easedColorVertices = [easedColorData mutableBytes];
  }
  
  return self;
}

- (GLKVector4 *)toColorVertices {
  if (toColorData == nil) {
    toColorData = [NSMutableData dataWithLength:sizeof(GLKVector4)*numVertices];
    toColorVertices = [toColorData mutableBytes];
  }
  return toColorVertices;
}

-(GLKVector4)easedColorForVertex:(int)i {
  return GLKVector4Add(self.fromColorVertices[i],GLKVector4MultiplyScalar(GLKVector4Subtract(self.toColorVertices[i], self.fromColorVertices[i]), self.easingFactor));
}

-(void)incrementElapsedTime:(double)time {
  [super incrementElapsedTime:time];
  
  for (int i = 0; i < numVertices; i++)
    easedColorVertices[i] = [self easedColorForVertex:i];
}

-(void)permanentize {
  for (int i = 0; i < numVertices; i++)
    self.node.shape.colorVertices[i] = toColorVertices[i];
}

@end
