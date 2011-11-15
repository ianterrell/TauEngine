//
//  TEShuffleBag.m
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import "TEShuffleBag.h"
#import "TERandom.h"

@implementation TEShuffleBag

-(id)initWithItems:(NSArray *)items autoReset:(BOOL)_autoReset {
  self = [super init];
  if (self) {
    [self setItems:items];
    autoReset = _autoReset;
    if (autoReset)
      resetItems = items;
  }
  
  return self;
}

-(void)setItems:(NSArray *)items {
  bag = [items mutableCopy];
}

-(void)reset {
  [self setItems:resetItems];
}

-(id)drawItem {
  int i = [TERandom randomTo:[bag count]];
  id item = [bag objectAtIndex:i];
  [bag removeObjectAtIndex:i];
  
  if (autoReset && [bag count] == 0)
    [self reset];
  
  return item;
}

@end
