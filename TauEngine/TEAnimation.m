//
//  TEAnimation.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@implementation TEAnimation

@synthesize node, next, elapsedTime, duration, repeat, easing, remove, reverse, onRemoval, onComplete;

- (id)init
{
  self = [super init];
  if (self) {
    easing = kTEAnimationEasingLinear;
    forward = YES;
    reverse = NO;
    permanent = NO;
    elapsedTime = 0.0;
  }
  
  return self;
}

-(id)initWithNode:(TENode *)_node
{
  self = [self init];
  if (self) {
    self.node = _node;
  }
  
  return self;
}

#pragma mark - Easing

-(float)percentDone {
  return forward ? elapsedTime/duration : 1.0 - elapsedTime/duration;
}

-(float)easingFactor {
  switch (easing) {
    case kTEAnimationEasingLinear:
      return self.percentDone;
    default:
      return 0.0;
  }
}

#pragma mark - Updating

-(void)incrementElapsedTime:(double)time {
  elapsedTime += time;
  if (elapsedTime >= duration) {
    // Reverse the animation if going forward and set to reverse
    if (forward && reverse) {
      elapsedTime -= duration;
      forward = !forward;
    } 
    // Repeat the animation if we have repeats left
    else if (repeat > 0 || repeat == kTEAnimationRepeatForever) {
      forward = !forward;
      elapsedTime -= duration;
      
      // Perform onComplete since a cycle is up
      if (onComplete != nil)
        onComplete();
      
      // Keep track of how many times we've repeated
      if (repeat > 0)
        repeat -= 1;
    } 
    // We're done!
    else {
      if (onComplete != nil)
        onComplete();
      if (permanent) {
        elapsedTime = 0;
        [self permanentize];
      }
      remove = YES;
    }
  }
}

#pragma mark - Going backward!

-(BOOL)backward {
  return !forward;
}

-(void)setBackward:(BOOL)backward {
  forward = !backward;
}

#pragma mark - Permanentizing

-(BOOL)permanent {
  return permanent;
}

-(void)setPermanent:(BOOL)_permanent {
  if (_permanent && node == nil)
    NSLog(@"WARNING! Permanentize will fail if node is not set.");
  permanent = _permanent;
}

-(void)permanentize {
  NSLog(@"Permanentize ot yet implemented by %@.", [[self class] description]);
}

@end
