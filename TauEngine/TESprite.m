//
//  TESprite.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TESprite.h"
#import "TauEngine.h"

@implementation TESprite

-(id)initWithImage:(UIImage *)image pointRatio:(float)ratio
{
  self = [super init];
  if (self) {
    renderStyle = kTERenderStyleTexture;
    effect = [TETexture effectWithTextureFromImage:image];
    
    self.width = image.size.width/ratio;
    self.height = image.size.height/ratio;
    
    self.textureCoordinates[0] = GLKVector2Make(1, 0);
    self.textureCoordinates[1] = GLKVector2Make(1, 1);
    self.textureCoordinates[2] = GLKVector2Make(0, 1);
    self.textureCoordinates[3] = GLKVector2Make(0, 0);
  }
  
  return self;
}

@end
