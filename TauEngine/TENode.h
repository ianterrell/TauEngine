//
//  TENode.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEDrawable.h"
#import "TEScene.h"
#import "TEShape.h"

@class TEAnimation;

@interface TENode : NSObject {
  NSString *name;
  TEDrawable *drawable;
  
  GLKVector2 position, velocity, acceleration;
  float rotation, angularVelocity, angularAcceleration;
  float scaleX, scaleY;
  
  float maxVelocity, maxAcceleration;
  float maxAngularVelocity, maxAngularAcceleration;
  
  NSMutableArray *currentAnimations;
  
  TENode *parent;
  NSMutableArray *children;
  
  BOOL remove;
  BOOL collide;
  BOOL renderChildrenFirst;
  
  GLKMatrix4 cachedObjectModelViewMatrix, cachedFullModelViewMatrix;
  BOOL dirtyObjectModelViewMatrix, dirtyFullModelViewMatrix;
}

@property GLKVector2 position, velocity, acceleration;
@property float scale, scaleX, scaleY;
@property float rotation, angularVelocity, angularAcceleration;

@property(strong, nonatomic) NSMutableArray *currentAnimations;
@property BOOL dirtyFullModelViewMatrix; // can be marked by parents

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) TEDrawable *drawable;
@property(readonly) TEShape *shape;
@property(strong, nonatomic) TENode *parent;
@property float maxVelocity, maxAcceleration, maxAngularVelocity, maxAngularAcceleration;
@property BOOL remove;
@property BOOL collide;
@property BOOL renderChildrenFirst;

# pragma mark Factories

+(TENode *)nodeWithDrawable:(TEDrawable *)drawable;

# pragma mark Update
-(void)update:(NSTimeInterval)dt inScene:(TEScene *)scene;

# pragma mark Motion Methods
-(void)updatePosition:(NSTimeInterval)dt inScene:(TEScene *)scene;

# pragma mark Position Shortcuts

-(void)wraparoundInScene:(TEScene *)scene;
-(void)wraparoundXInScene:(TEScene *)scene;
-(void)wraparoundYInScene:(TEScene *)scene;

-(void)bounceXInScene:(TEScene *)scene buffer:(float)buffer;
-(void)bounceXInScene:(TEScene *)scene bufferLeft:(float)left bufferRight:(float)right;
-(void)bounceYInScene:(TEScene *)scene buffer:(float)buffer;
-(void)bounceYInScene:(TEScene *)scene bufferTop:(float)top bufferBottom:(float)bottom;

-(void)removeOutOfScene:(TEScene *)scene buffer:(float)buffer;

-(GLKVector2)vectorToNode:(TENode *)node;

# pragma mark Animation Methods

-(void)startAnimation:(TEAnimation *)animation;

# pragma mark Tree Methods

-(void)addChild:(TENode *)child;
-(void)traverseUsingBlock:(void (^)(TENode *))block;
-(TENode *)childNamed:(NSString *)name;
-(NSArray *)childrenNamed:(NSArray *)names;

# pragma mark Callbacks

-(void)onRemoval;

# pragma mark Communicating with outside world

-(void)postNotification:(NSString *)notificationName;

# pragma mark Rendering

-(void)renderInScene:(TEScene *)scene;

# pragma mark Matrix Methods

-(GLKMatrix4)modelViewMatrix;
-(void)markModelViewMatrixDirty;
-(BOOL)hasCustomTransformation;
-(GLKMatrix4)customTransformation;

@end
