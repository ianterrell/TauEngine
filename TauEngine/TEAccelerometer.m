//
//  TEAccelerometer.m
//  TauGame
//
//  Created by Ian Terrell on 7/20/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAccelerometer.h"

static double previousHorizontal = 0.0;
static double kFilterFactor = 0.05;
static CMAcceleration calibration;

@implementation TEAccelerometer;

+(void)zero {
  calibration = [TauEngine motionManager].accelerometerData.acceleration;
}

+(float)horizontalForOrientation:(UIInterfaceOrientation)orientation {
  CMAcceleration accel = [TauEngine motionManager].accelerometerData.acceleration;
  float horizontal;
  
  if (orientation == UIInterfaceOrientationPortrait)
    horizontal = (accel.x - calibration.x);
  else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    horizontal = -1*(accel.x - calibration.x);
  else if (orientation == UIInterfaceOrientationLandscapeLeft)
    horizontal = (accel.y - calibration.y);
  else if (orientation == UIInterfaceOrientationLandscapeRight)
    horizontal = -1*(accel.y - calibration.y);
  else
    horizontal = (accel.x - calibration.x);
  
  horizontal = horizontal*kFilterFactor+(1-kFilterFactor)*previousHorizontal;
  previousHorizontal = horizontal;
  return horizontal;
}

@end
