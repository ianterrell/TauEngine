//
//  TETexture.m
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TETexture.h"

@implementation TETexture

# pragma mark Making Textures

+(GLKTextureInfo *)textureFromImage:(UIImage*)image {
  NSError *error;
  GLKTextureInfo *texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
  if (error) {
    NSLog(@"Error loading texture from image: %@",error);
  }
  return texture;
}

# pragma mark Making Effects

+(GLKBaseEffect *)effectWithTexture:(GLKTextureInfo *)texture {
  GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
  effect.texture2d0.envMode = GLKTextureEnvModeReplace;
  effect.texture2d0.target = GLKTextureTarget2D;
  effect.texture2d0.name = texture.name;
  return effect;
}

+(GLKBaseEffect *)effectWithTextureFromImage:(UIImage*)image {
  return [self effectWithTexture:[self textureFromImage:image]];
}



@end
