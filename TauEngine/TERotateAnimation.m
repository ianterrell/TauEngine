//
//  TERotateAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TERotateAnimation.h"

@implementation TERotateAnimation

@synthesize rotation;

- (id)init
{
  self = [super init];
  if (self) {
    rotation = 0.0;
  }
  
  return self;
}

-(float)easedRotation {
  return self.easingFactor * rotation;
}

-(void)permanentize {
  self.node.rotation += rotation;
}

@end
