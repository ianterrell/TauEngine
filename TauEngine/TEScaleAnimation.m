//
//  TEScaleAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScaleAnimation.h"

@implementation TEScaleAnimation

@synthesize scaleX, scaleY;

- (id)init
{
  self = [super init];
  if (self) {
    self.scale = 1.0;
  }
  
  return self;
}

-(float)scale {
  return scaleX;
}

-(void)setScale:(float)scale {
  scaleX = scaleY = scale;
}

-(float)easedScale {
  return [self easedScaleX];
}

-(float)easedScaleX {
  return 1.0 + self.easingFactor * (scaleX - 1.0);
}

-(float)easedScaleY {
  return 1.0 + self.easingFactor * (scaleY - 1.0);
}

-(void)permanentize {
  self.node.scaleX *= scaleX;
  self.node.scaleY *= scaleY;
}

@end
