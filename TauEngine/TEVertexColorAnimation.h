//
//  TEVertexColorAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/30/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@interface TEVertexColorAnimation : TEAnimation {
  int numVertices;
  NSMutableData *fromColorData, *toColorData, *easedColorData;
  GLKVector4 *fromColorVertices, *toColorVertices, *easedColorVertices;
}

@property(readonly) GLKVector4 *fromColorVertices, *toColorVertices, *easedColorVertices;

-(GLKVector4)easedColorForVertex:(int)i;

@end
