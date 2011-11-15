;//
//  TEShape.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEShape.h"
#import "TEEllipse.h"

#define RenderStyleIs(x) ((renderStyle & x) == x)

static GLKBaseEffect *defaultEffect;
static GLKBaseEffect *constantColorEffect;

@implementation TEShape

@synthesize effect, renderStyle, color, colorData;

+(void)initialize {
  defaultEffect = [[GLKBaseEffect alloc] init];
  
  constantColorEffect = [[GLKBaseEffect alloc] init];
  constantColorEffect.useConstantColor = YES;
}

- (id)init
{
  self = [super init];
  if (self) {
    renderStyle = kTERenderStyleConstantColor;
  }
  
  return self;
}

-(int)numVertices {
  return 0;
}

- (GLKVector2 *)vertices {
  if (vertexData == nil) {
    vertexData = [NSMutableData dataWithLength:sizeof(GLKVector2)*self.numVertices];
    vertices = [vertexData mutableBytes];
  }
  return vertices;
}

-(GLKVector2 *)textureCoordinates {
  if (textureData == nil) {
    textureData = [NSMutableData dataWithLength:sizeof(GLKVector2)*self.numVertices];
    textureCoordinates = [textureData mutableBytes];
  }
  return textureCoordinates;
}

-(GLKVector4 *)colorVertices {
  if (colorData == nil) {
    colorData = [NSMutableData dataWithLength:sizeof(GLKVector4)*self.numVertices];
    colorVertices = [colorData mutableBytes];
  }
  return colorVertices;
}

-(void)updateVertices {
}

-(GLenum)renderMode {
  return GL_TRIANGLE_FAN;
}

-(void)renderInScene:(TEScene *)scene {
  if (renderStyle == kTERenderStyleNone)
    return;
  
  __block GLKVector4 *displayColorVertices;
  
  // Initialize the effect if necessary
  if (effect == nil) {
    if (RenderStyleIs(kTERenderStyleConstantColor))
      effect = constantColorEffect;
    else if (RenderStyleIs(kTERenderStyleVertexColors))
      effect = defaultEffect;
  }
  
  effect.transform.modelviewMatrix = [node modelViewMatrix];
  effect.transform.projectionMatrix = [scene projectionMatrix];
  
  // Set up effect specifics
  if (RenderStyleIs(kTERenderStyleConstantColor)) {
    effect.constantColor = color;
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TEColorAnimation class]]) {
        TEColorAnimation *colorAnimation = (TEColorAnimation *)animation;
        effect.constantColor = GLKVector4Add(self.effect.constantColor, colorAnimation.easedColor);
      }
    }];
  } else if (RenderStyleIs(kTERenderStyleVertexColors)) {
    displayColorVertices = colorVertices;
    [node.currentAnimations enumerateObjectsUsingBlock:^(id animation, NSUInteger idx, BOOL *stop){
      if ([animation isKindOfClass:[TEVertexColorAnimation class]]) {
        TEVertexColorAnimation *colorAnimation = (TEVertexColorAnimation *)animation;
        displayColorVertices = colorAnimation.easedColorVertices;
      }
    }];
  }
  
  // Finalize effect
  [effect prepareToDraw];
  
  // Set up transparency
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  
  // Set up position vertices
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
  
  // Set up color vertices
  if (RenderStyleIs(kTERenderStyleVertexColors)) {
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, displayColorVertices);
  }
  
  // Set up texture vertices
  if (RenderStyleIs(kTERenderStyleTexture)) {
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, textureCoordinates);
  }
  
  // Draw arrays
  glDrawArrays(self.renderMode, 0, self.numVertices);
  
  // Tear down position vertices
  glDisableVertexAttribArray(GLKVertexAttribPosition);
  
  // Tear down color vertices
  if (RenderStyleIs(kTERenderStyleVertexColors))
    glDisableVertexAttribArray(GLKVertexAttribColor);
  
  // Tear down texture vertices
  if (RenderStyleIs(kTERenderStyleTexture))
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
  
  // Disable transparency
  glDisable(GL_BLEND);
}

-(BOOL)isPolygon {
  return ![self isCircle];
}

-(BOOL)isCircle {
  return [self isKindOfClass:[TEEllipse class]];
}

-(float)radius {
  return 0.0;
}

@end
