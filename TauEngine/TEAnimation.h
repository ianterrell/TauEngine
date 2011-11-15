//
//  TEAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "TENode.h"

typedef enum {
  kTEAnimationEasingLinear,
} TEAnimationEasingType;

#define kTEAnimationRepeatForever -1

@interface TEAnimation : NSObject {
  TENode *node;
  TEAnimationEasingType easing;
  double elapsedTime, duration;
  int repeat;
  BOOL remove, reverse, forward, permanent;
  void (^onRemoval)(void);
  void (^onComplete)(void);
  
  TEAnimation *next;
}

@property(strong) TENode *node;
@property(strong) TEAnimation *next;
@property TEAnimationEasingType easing;
@property double elapsedTime, duration;
@property int repeat;
@property BOOL remove, reverse, backward, permanent;
@property(nonatomic,copy) void (^onRemoval)(void);
@property(nonatomic,copy) void (^onComplete)(void);

@property(readonly) float percentDone;
@property(readonly) float easingFactor;

-(id)initWithNode:(TENode *)_node;

-(void)incrementElapsedTime:(double)time;

-(void)permanentize;

@end
