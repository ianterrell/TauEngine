//
//  TETranslateAnimation.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEAnimation.h"

@interface TETranslateAnimation : TEAnimation {
  GLKVector2 translation;
}

@property GLKVector2 translation;
@property(readonly) GLKVector2 easedTranslation;

@end
