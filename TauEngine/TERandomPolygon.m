//
//  TERandomPolygon.m
//  TauGame
//
//  Created by Ian Terrell on 7/29/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TERandomPolygon.h"
#import "TauEngine.h"

@implementation TERandomPolygon

@synthesize numSides;

-(id)initWithSides:(int)num lowerFactor:(float)lower upperFactor:(float)upper
{
  self = [super initWithVertices:num+2];
  if (self) {
    numSides = num;
    lowerFactor = lower;
    upperFactor = upper;
    [self updateVertices];
  }
  
  return self;
}

-(int)numEdges {
  return numVertices-2;
}

-(int)edgeVerticesOffset {
  return 1;
}

-(void)updateVertices {
  self.vertices[0] = GLKVector2Make(0,0);
  for (int i = 0; i < numSides; i++) {
    float theta = ((float)i) / numSides * M_TAU;
    self.vertices[i+1] = GLKVector2Make(cos(theta)*[TERandom randomFractionFrom:lowerFactor to:upperFactor], sin(theta)*[TERandom randomFractionFrom:lowerFactor to:upperFactor]);
  }
  self.vertices[numSides+1] = self.vertices[1];
}

@end
