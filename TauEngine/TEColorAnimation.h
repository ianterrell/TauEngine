//
//  TEColorAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

/**
 * TEColorAnimation animates the color of the shape of the TENode.
 *
 * The drawable must be set in order to get the shape's previous color, and initWithDrawable: is the preferred initialization.
 */
@interface TEColorAnimation : TEAnimation {
  
  /**
   * The color to transition to
   */
  GLKVector4 color;
  
  /**
   * The color that it was originally, in order to calculate the easing for the animation.
   * This will be set automatically if the drawable is set.
   */
  GLKVector4 previousColor;
}

@property GLKVector4 color, previousColor;
@property(readonly) GLKVector4 easedColor;

@end
