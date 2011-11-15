//
//  TEDrawable.h
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class TENode;
@class TEScene;

@interface TEDrawable : NSObject {
  TENode *node;
}

@property(strong, nonatomic) TENode *node;

-(void)renderInScene:(TEScene *)scene;

@end
