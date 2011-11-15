//
//  TEEngine.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#define M_TAU (2*M_PI)

#define TE_ELLIPSE_RESOLUTION 62
#define TE_ELLIPSE_NUM_VERTICES (TE_ELLIPSE_RESOLUTION + 2)

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>

#import "TEDrawable.h"

#import "TENode.h"

#import "TEShape.h"
#import "TEPolygon.h"
#import "TETriangle.h"
#import "TERectangle.h"
#import "TEHexagon.h"
#import "TEHeptagon.h"
#import "TEOctagon.h"
#import "TEEllipse.h"
#import "TERegularPolygon.h"
#import "TERandomPolygon.h"

#import "TENumberDisplay.h"

#import "TESprite.h"

#import "TESceneController.h"
#import "TEScene.h"
#import "TEMenu.h"

#import "TENodeLoader.h"

#import "TEAnimation.h"
#import "TEScaleAnimation.h"
#import "TETranslateAnimation.h"
#import "TERotateAnimation.h"
#import "TEColorAnimation.h"
#import "TEVertexColorAnimation.h"

#import "TECollisionDetector.h"

#import "TEAccelerometer.h"

#import "TESoundManager.h"

#import "TERandom.h"
#import "TEShuffleBag.h"
#import "TEImage.h"
#import "TETexture.h"

@interface TauEngine : NSObject {
  CMMotionManager *motionManager;
}

+(CMMotionManager *)motionManager;

@end

