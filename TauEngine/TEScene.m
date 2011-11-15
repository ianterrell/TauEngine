//
//  TEScene.m
//  TauGame
//
//  Created by Ian Terrell on 7/11/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEScene.h"
#import "TauEngine.h"

@implementation TEScene

@synthesize left, right, bottom, top;
@synthesize clearColor;
@synthesize characters;

- (id)initWithFrame:(CGRect)frame {
  self = [super init];
  if (self) {
    // OPTIMIZATION: configurable multisample
    self.view.frame = frame;
    
    self.delegate = self;
    ((GLKView*)self.view).delegate = self;
    ((GLKView*)self.view).drawableMultisample = GLKViewDrawableMultisampleNone;// 4X;
    self.preferredFramesPerSecond = 60;
    
    characters = [[NSMutableArray alloc] init];
    charactersToAdd = [[NSMutableArray alloc] init];
    
    dirtyProjectionMatrix = YES;
  }
  
  return self;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
  GLfloat timeSince = [controller timeSinceLastDraw]; // FIXME should really be timeSinceLastUpdate, but it's buggy
  
  // Update all characters
  for (TENode *character in characters)
    [character update:timeSince inScene:self];

  // Remove any who declared they need removed
  NSMutableArray *removed = [[NSMutableArray alloc] init];
  [characters filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TENode *character, NSDictionary *bindings) {
    if (character.remove) {
      [removed addObject:character];
      return NO;
    } else
      return YES;
  }]];
  for (TENode *character in removed) {
    [self nodeRemoved:character];
    [character onRemoval];
  }
  
  // Add any who were created in update
  [characters addObjectsFromArray:charactersToAdd];
  [charactersToAdd removeAllObjects];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self render];
}

# pragma mark - Scene Setup

-(void)setLeft:(GLfloat)_left right:(GLfloat)_right bottom:(GLfloat)_bottom top:(GLfloat)_top {
  left = _left;
  right = _right;
  bottom = _bottom;
  top = _top;
  dirtyProjectionMatrix = YES;
  [self markChildrensFullMatricesDirty];
}

-(float)width {
  return right-left;
}

-(float)height {
  return top-bottom;
}

-(float)visibleWidth {
  return self.topRightVisible.x - self.bottomLeftVisible.x;
}

-(float)visibleHeight {
  return self.topRightVisible.y - self.bottomLeftVisible.y;
}

-(GLKVector2)center {
  return GLKVector2Make((self.topRightVisible.x + self.bottomLeftVisible.x)/2, (self.topRightVisible.y + self.bottomLeftVisible.y)/2);
}

-(GLKVector2)bottomLeftVisible {
  return GLKVector2Make(left, bottom);
}

-(GLKVector2)topRightVisible {
  return GLKVector2Make(right, top);
}

# pragma mark - Helpers

-(GLKVector2)positionForLocationInView:(CGPoint)location {
  float xPercent = location.x / self.view.frame.size.width;
  float yPercent = location.y / self.view.frame.size.height;
  return GLKVector2Make(left+xPercent*self.width, top-(yPercent*self.height));
}

-(CGPoint)locationInViewForPosition:(GLKVector2)position {
  float xPercent = (right - position.x) / (right - left);
  float yPercent = (top - position.y) / (top - bottom);
  return CGPointMake(xPercent*self.view.frame.size.width, self.view.frame.size.height-(yPercent*self.view.frame.size.height));
}

# pragma mark - Scene Transitions

- (void)viewWillAppear:(BOOL)animated {
  NSLog(@"scene view will appear");
  self.paused = YES;
}

-(void)viewDidAppear:(BOOL)animated {
  NSLog(@"scene view did appear");
  self.paused = NO;
}

# pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  self.paused = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  self.paused = NO;
}

# pragma mark - Rendering

-(void)markChildrensFullMatricesDirty {
  [characters makeObjectsPerformSelector:@selector(traverseUsingBlock:) withObject:^(TENode *node) {
    node.dirtyFullModelViewMatrix = YES;
  }];
}

-(void)render {
  glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
  glClear(GL_COLOR_BUFFER_BIT);
  
  [characters makeObjectsPerformSelector:@selector(renderInScene:) withObject:self];
}

-(GLKMatrix4)projectionMatrix {
  if (dirtyProjectionMatrix) {
    cachedProjectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1.0, -1.0);
    dirtyProjectionMatrix = NO;
  }
  return cachedProjectionMatrix;
}

# pragma mark Scene Updating

-(void)addCharacterAfterUpdate:(TENode *)node {
  [charactersToAdd addObject:node];
}

-(void)nodeRemoved:(TENode *)node {
}

@end
