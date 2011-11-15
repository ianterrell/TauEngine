//
//  TERotateAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@interface TERotateAnimation : TEAnimation {
  float rotation;
}

@property float rotation;
@property(readonly) float easedRotation;

@end
