//
//  TauEngine.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"


static CMMotionManager *motionManager = nil;

@implementation TauEngine

+(CMMotionManager *)motionManager {
  if (motionManager == nil) {
    motionManager = [[CMMotionManager alloc] init];
  }
  return motionManager;
}

@end
