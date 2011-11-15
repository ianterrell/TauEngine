//
//  TEScaleAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@interface TEScaleAnimation : TEAnimation {
  float scaleX, scaleY;
}

@property float scale, scaleX, scaleY;
@property(readonly) float easedScale;
@property(readonly) float easedScaleX;
@property(readonly) float easedScaleY;

@end
