//
//  TEShuffleBag.h
//  TauGame
//
//  Created by Ian Terrell on 8/8/11.
//  Copyright (c) 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEShuffleBag : NSObject {
  NSMutableArray *bag;
  NSArray *resetItems;
  BOOL autoReset;
}

-(id)initWithItems:(NSArray *)items autoReset:(BOOL)autoReset;
-(void)setItems:(NSArray *)items;
-(void)reset;
-(id)drawItem;

@end
