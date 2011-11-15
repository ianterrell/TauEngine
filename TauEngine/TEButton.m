//
//  TEButton.m
//  TauGame
//
//  Created by Ian Terrell on 8/12/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TEButton.h"

@implementation TEButton

@synthesize action;

+(TEButton *)buttonWithDrawable:(TEDrawable *)drawable {
  TEButton *node = [[TEButton alloc] init];
  node.drawable = drawable;
  return node;
}

-(void)highlight {
}

-(void)unhighlight {
}

-(void)fire {
  if (action != nil)
    action();
}

@end
