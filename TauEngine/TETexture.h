//
//  TETexture.h
//  TauGame
//
//  Created by Ian Terrell on 8/4/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TETexture : NSObject

# pragma mark Making Textures

+(GLKTextureInfo *)textureFromImage:(UIImage*)image;

# pragma mark Making Effects

+(GLKBaseEffect *)effectWithTexture:(GLKTextureInfo *)texture;
+(GLKBaseEffect *)effectWithTextureFromImage:(UIImage*)image;

@end
