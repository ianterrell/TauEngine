//
//  TECollisionDetectorTest.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECollisionDetectorTest.h"
#import "TauEngine.h"
#import <GLKit/GLKit.h>

static int count = 0;

@implementation TECollisionDetectorTest

+(TENode *)nodeWithShape:(TEShape *)shape; {
  TENode *node = [[TENode alloc] init];
  node.drawable = shape;
  node.drawable.node = node;
  node.collide = YES;
  return node;
}

+(TEShape *)circleShape {
  TEEllipse *circle = [[TEEllipse alloc] init];
  circle.radiusX = circle.radiusY = 1.0;
  return circle;
}

+(TENode *)circleNode {
  return [self nodeWithShape:[self circleShape]];
}

+(TEShape *)triangleShape {
  TETriangle *triangle = [[TETriangle alloc] init];
  triangle.vertices[0] = GLKVector2Make(0,0);
  triangle.vertices[1] = GLKVector2Make(1,0);
  triangle.vertices[2] = GLKVector2Make(0,1);
  return triangle;
}

+(TENode *)triangleNode {
  return [self nodeWithShape:[self triangleShape]];
}

+(TEShape *)squareShape {
  TERectangle *square = [[TERectangle alloc] init];
  square.width = square.height = 1.0;
  return square;
}

+(TENode *)squareNode {
  return [self nodeWithShape:[self squareShape]];
}

+(void)testNode:(TENode *)node1 collidingWithNode:(TENode *)node2 recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight desired:(BOOL)desired label:(NSString *)label {
  count++;
  if ([TECollisionDetector node:node1 collidesWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight] == desired)
    NSLog(@"     %3d — %@", count, label);
  else
    NSLog(@"FAIL %3d — %@", count, label);
}

+(void)node:(TENode *)node1 shouldCollideWith:(TENode *)node2 recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight label:(NSString *)label {
  [self testNode:node1 collidingWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight desired:YES label:label];
}

+(void)node:(TENode *)node1 shouldNotCollideWith:(TENode *)node2 recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight label:(NSString *)label {
  [self testNode:node1 collidingWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight desired:NO label:label];
}

+(void)node:(TENode *)node1 shouldCollideWith:(TENode *)node2 label:(NSString *)label {
  [self node:node1 shouldCollideWith:node2 recurseLeft:NO recurseRight:NO label:label];
}

+(void)node:(TENode *)node1 shouldNotCollideWith:(TENode *)node2 label:(NSString *)label {
  [self node:node1 shouldNotCollideWith:node2 recurseLeft:NO recurseRight:NO label:label];
}

+(void)test {
  //////
  ///// Circle Circle
  ////
  
  TENode *circle1 = [self circleNode];
  TENode *circle2 = [self circleNode];
  
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles overlapping completely"];
  
  circle1.position = GLKVector2Make(0.5,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles overlapping some"];
  
  circle1.position = GLKVector2Make(2,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles touching"];
  
  circle1.position = GLKVector2Make(3,0);
  [self node:circle1 shouldNotCollideWith:circle2 label:@"Circles not touching"];
  
  
  circle1.scale = 5;
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles scaled up touching"];
  
  circle1.position = GLKVector2Make(0,0);
  circle1.scale = 1.0;//reset
    
  TENode *subCircle1 = [self circleNode];
  subCircle1.position = GLKVector2Make(-2,0);
  [circle1 addChild:subCircle1];
  
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles w/sub overlapping completely"];
  
  circle1.position = GLKVector2Make(2,0);
  [self node:circle1 shouldCollideWith:circle2 label:@"Circles w/sub touching"];
  
  circle1.position = GLKVector2Make(4,0);
  [self node:circle1 shouldNotCollideWith:circle2 label:@"Circles w/sub has sub touching no recursive"];

  [self node:circle1 shouldCollideWith:circle2 recurseLeft:YES recurseRight:YES label:@"Circles w/sub has sub touching with recursive"];
  
  circle1.position = GLKVector2Make(5,0);
  [self node:circle1 shouldNotCollideWith:circle2 recurseLeft:YES recurseRight:YES label:@"Circles w/sub has sub not touching with recursive"];
  
  circle1.position = GLKVector2Make(0,4);
  circle1.rotation = 0.25*M_TAU;
  [self node:circle1 shouldNotCollideWith:circle2 label:@"Circles w/sub & rotated has sub touching no recursive"];
  
  [self node:circle1 shouldCollideWith:circle2 recurseLeft:YES recurseRight:YES label:@"Circles w/sub & rotated has sub touching with recursive"];
  
  circle1.position = GLKVector2Make(0,5);
  [self node:circle1 shouldNotCollideWith:circle2 recurseLeft:YES recurseRight:YES label:@"Circles w/sub & rotated has sub not touching with recursive"];
  
  //////
  ///// Triangle Triangle
  ////
  
  TENode *triangle1 = [self triangleNode];
  TENode *triangle2 = [self triangleNode];
  
  [self node:triangle1 shouldCollideWith:triangle2 label:@"Triangles overlapping completely"];
  
  triangle1.position = GLKVector2Make(0.5,0);
  [self node:triangle1 shouldCollideWith:triangle2 label:@"Triangles overlapping some"];
  
  triangle1.position = GLKVector2Make(1,0);
  [self node:triangle1 shouldCollideWith:triangle2 label:@"Triangles touching"];
  
  triangle1.position = GLKVector2Make(5,0);
  [self node:triangle1 shouldNotCollideWith:triangle2 label:@"Triangles not touching"];
  
  //////
  ///// Squares
  ////
  
  TENode *square1 = [self squareNode];
  TENode *square2 = [self squareNode];
  
  [self node:square1 shouldCollideWith:square2 label:@"Squares overlapping completely"];
  
  square1.position = GLKVector2Make(0.5,0);
  [self node:square1 shouldCollideWith:square2 label:@"Squares overlapping some"];
  
  square1.position = GLKVector2Make(1.0,0);
  [self node:square1 shouldCollideWith:square2 label:@"Squares touching"];
  
  square1.position = GLKVector2Make(5,0);
  [self node:square1 shouldNotCollideWith:square2 label:@"Squares not touching"];
}

@end
