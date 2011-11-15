//
//  TEButton.h
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TENode.h"

@interface TEButton : TENode {
  void (^action)(void);
}

@property(nonatomic,copy) void (^action)(void);

+(TEButton *)buttonWithDrawable:(TEDrawable *)drawable;

-(void)highlight;
-(void)unhighlight;
-(void)fire;

@end
