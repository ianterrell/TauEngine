//
//  TESceneController.m
//  TauGame
//
//  Created by Ian Terrell on 7/18/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TESceneController.h"

#define DEFAULT_SCENE_TRANSITION_DURATION 1
#define DEFAULT_SCENE_TRANSITION_OPTIONS (UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionTransitionCrossDissolve)

NSString * const kTEPreviousScene = @"kTEPreviousScene";

@implementation TESceneController

@synthesize container, context, currentScene, currentSceneName, scenes;

- (id)init
{
  self = [super init];
  if (self) {
    scenes = [[NSMutableDictionary alloc] init];
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    container = [[UIView alloc] initWithFrame:self.view.frame];
    container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:container];
  }
  
  return self;
}

# pragma mark Scene Management

-(TEScene *)sceneNamed:(NSString *)name {
  return [scenes objectForKey:name];
}

-(void)addSceneOfClass:(Class)sceneClass named:(NSString *)name {
  [self addScene:[[sceneClass alloc] initWithFrame:self.container.frame] named:name];
}

-(void)addScene:(UIViewController *)scene named:(NSString *)name {
  [self addChildViewController:scene];
  
  if ([scene isKindOfClass:[GLKViewController class]])
    ((GLKView*)scene.view).context = context;
  [scenes setObject:scene forKey:name];
}

-(void)removeScene:(NSString *)name {
  [[scenes objectForKey:name] removeFromParentViewController];
  [scenes removeObjectForKey:name];
}

-(void)displayScene:(NSString *)name {
  [self displayScene:name duration:DEFAULT_SCENE_TRANSITION_DURATION options:DEFAULT_SCENE_TRANSITION_OPTIONS completion:NULL];
}

-(void)displayScene:(NSString *)name  duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
  UIViewController *newScene = name == kTEPreviousScene ? previousScene : [scenes objectForKey:name];
  if (currentScene == nil)
    [container addSubview:newScene.view];
  else {
    previousScene = currentScene;
    [UIView transitionFromView:currentScene.view toView:newScene.view duration:duration options:options completion:completion];
  }
  currentScene = newScene;
  currentSceneName = name;
}

-(void)replaceCurrentSceneWithScene:(UIViewController *)scene named:(NSString*)name {
  [self replaceCurrentSceneWithScene:scene named:name duration:DEFAULT_SCENE_TRANSITION_DURATION options:DEFAULT_SCENE_TRANSITION_OPTIONS completion:NULL];
}

-(void)replaceCurrentSceneWithScene:(UIViewController *)scene named:(NSString *)name duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
  NSString *oldScene = currentSceneName;
  [self addScene:scene named:name];
  [self displayScene:name duration:duration options:options completion:^(BOOL finished){
    [self removeScene:oldScene];
    if (completion != NULL)
      completion(finished);
  }];
}

# pragma mark Device Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (currentScene != nil)
    return [currentScene shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
  else
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
