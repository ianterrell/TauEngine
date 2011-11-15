//
//  TESceneController.h
//  TauGame
//
//  Created by Ian Terrell on 7/18/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "TEScene.h"

extern NSString *const kTEPreviousScene;

@interface TESceneController : UIViewController {
  UIView *container;
  
  EAGLContext *context;
  NSMutableDictionary *scenes;
  UIViewController *currentScene, *previousScene;
}

@property(strong, readonly) UIView *container;
@property(strong, readonly) EAGLContext *context;
@property(strong, readonly) UIViewController *currentScene;
@property(strong, readonly) NSString *currentSceneName;
@property(strong, readonly) NSMutableDictionary *scenes;

# pragma mark Scene Management

-(TEScene *)sceneNamed:(NSString *)name;
-(void)addSceneOfClass:(Class)sceneClass named:(NSString *)name;
-(void)addScene:(UIViewController *)scene named:(NSString *)name;
-(void)removeScene:(NSString *)name;
-(void)displayScene:(NSString *)name;
-(void)displayScene:(NSString *)name  duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

-(void)replaceCurrentSceneWithScene:(UIViewController *)scene named:(NSString*)name;
-(void)replaceCurrentSceneWithScene:(UIViewController *)scene named:(NSString *)name  duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

@end
