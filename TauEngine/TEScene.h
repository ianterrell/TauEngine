//
//  TEScene.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "TENode.h"

@interface TEScene : GLKViewController <GLKViewDelegate, GLKViewControllerDelegate> {
  GLfloat left, right, bottom, top;
  GLKVector4 clearColor;
  NSMutableArray *characters, *charactersToAdd;
  
  GLKMatrix4 cachedProjectionMatrix;
  BOOL dirtyProjectionMatrix;
}

@property(readonly) GLfloat left, right, bottom, top;
@property(readonly) float width, height;
@property GLKVector4 clearColor;
@property(strong, nonatomic) NSMutableArray *characters;

# pragma mark Scene Setup

-(id)initWithFrame:(CGRect)frame;

-(void)setLeft:(GLfloat)left right:(GLfloat)right bottom:(GLfloat)bottom top:(GLfloat)top;
@property(readonly) float visibleWidth, visibleHeight;
@property(readonly) GLKVector2 center;
@property(readonly) GLKVector2 bottomLeftVisible;
@property(readonly) GLKVector2 topRightVisible;

# pragma mark - Helpers

-(GLKVector2)positionForLocationInView:(CGPoint)location;
-(CGPoint)locationInViewForPosition:(GLKVector2)position;

# pragma mark Rendering

-(void)render;
-(void)markChildrensFullMatricesDirty;
-(GLKMatrix4)projectionMatrix;

# pragma mark Scene Updating

-(void)addCharacterAfterUpdate:(TENode *)node;
-(void)nodeRemoved:(TENode *)node;

@end
