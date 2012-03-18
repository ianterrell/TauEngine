//
//  TECollisionDetectorTests.m
//  TauEngine
//
//  Created by Ian Terrell on 3/18/12.
//  Copyright (c) 2012 Ian Terrell. All rights reserved.
//

#import "TauEngine.h"
#import "TECollisionDetectorTestCase.h"

@implementation TECollisionDetectorTestCase

TENode *circle1, *circle2, *subCircle, *triangle1, *triangle2, *square1, *square2;


#pragma mark -
#pragma mark Factory Methods


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


#pragma mark -
#pragma mark Circle Circle Collision Tests


-(void)setupCircleTests {
  circle1 = [[self class] circleNode];
  circle2 = [[self class] circleNode];
}

-(void)setupSubcircleTests {
  [self setupCircleTests];
  subCircle = [[self class] circleNode];
  subCircle.position = GLKVector2Make(-2,0);
  [circle1 addChild:subCircle];
}

-(void)testCompletelyOverlappingCirclesShouldCollide {
  [self setupCircleTests];
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testSomewhatOverlappingCirclesShouldCollide {
  [self setupCircleTests];
  circle1.position = GLKVector2Make(0.5,0);
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testTouchingCirclesShouldCollide {
  [self setupCircleTests];
  circle1.position = GLKVector2Make(2,0);
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testNotTouchingCirclesShouldNotCollide {
  [self setupCircleTests];
  circle1.position = GLKVector2Make(3,0);
  STAssertFalse([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testScaledUpOverlappingCirclesShouldCollide {
  [self setupCircleTests];
  circle1.position = GLKVector2Make(3,0);
  circle1.scale = 5;
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testOverlappingCirclesWithSubShouldCollide {
  [self setupSubcircleTests];
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testTouchingCirclesWithSubShouldCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(2,0);
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testCirclesWithSubTouchingWithoutRecursiveShouldNotCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(4,0);
  STAssertFalse([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testCirclesWithSubTouchingWithRecursiveShouldCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(4,0);
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:YES recurseRight:YES], NSStringFromSelector(_cmd));
}

-(void)testCirclesWithSubNotTouchingWithRecursiveShouldNotCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(5,0);
  STAssertFalse([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:YES recurseRight:YES], NSStringFromSelector(_cmd));
}

-(void)testCirclesWithSubTouchingAndRotatedWithoutRecursiveShouldNotCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(0,4);
  circle1.rotation = 0.25*M_TAU;
  STAssertFalse([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testCirclesWithSubTouchingAndRotatedWithRecursiveShouldCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(0,4);
  circle1.rotation = 0.25*M_TAU;
  STAssertTrue([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:YES recurseRight:YES], NSStringFromSelector(_cmd));
}

-(void)testCirclesWithSubNotTouchingAndRotatedWithRecursiveShouldNotCollide {
  [self setupSubcircleTests];
  circle1.position = GLKVector2Make(0,5);
  circle1.rotation = 0.25*M_TAU;
  STAssertFalse([TECollisionDetector node:circle1 collidesWithNode:circle2 recurseLeft:YES recurseRight:YES], NSStringFromSelector(_cmd));
}


#pragma mark -
#pragma mark Triangle Triangle Collision Tests


-(void)setupTriangleTests {
  triangle1 = [[self class] triangleNode];
  triangle2 = [[self class] triangleNode];
}

-(void)testCompletelyOverlappingTrianglesShouldCollide {
  [self setupTriangleTests];
  STAssertTrue([TECollisionDetector node:triangle1 collidesWithNode:triangle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testSomewhatOverlappingTrianglesShouldCollide {
  [self setupTriangleTests];
  triangle1.position = GLKVector2Make(0.5,0);
  STAssertTrue([TECollisionDetector node:triangle1 collidesWithNode:triangle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testTouchingTrianglesShouldCollide {
  [self setupTriangleTests];
  triangle1.position = GLKVector2Make(1,0);
  STAssertTrue([TECollisionDetector node:triangle1 collidesWithNode:triangle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testNotTouchingTrianglesShouldNotCollide {
  [self setupTriangleTests];
  triangle1.position = GLKVector2Make(5,0);
  STAssertFalse([TECollisionDetector node:triangle1 collidesWithNode:triangle2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}


#pragma mark -
#pragma mark Square Square Collision Tests


-(void)setupSquareTests {
  square1 = [[self class] squareNode];
  square2 = [[self class] squareNode];
}

-(void)testCompletelyOverlappingSquaresShouldCollide {
  [self setupSquareTests];
  STAssertTrue([TECollisionDetector node:square1 collidesWithNode:square2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testSomewhatOverlappingSquaresShouldCollide {
  [self setupSquareTests];
  square1.position = GLKVector2Make(0.5,0);
  STAssertTrue([TECollisionDetector node:square1 collidesWithNode:square2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testTouchingSquaresShouldCollide {
  [self setupSquareTests];
  square1.position = GLKVector2Make(1,0);
  STAssertTrue([TECollisionDetector node:square1 collidesWithNode:square2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}

-(void)testNotTouchingSquaresShouldNotCollide {
  [self setupSquareTests];
  square1.position = GLKVector2Make(5,0);
  STAssertFalse([TECollisionDetector node:square1 collidesWithNode:square2 recurseLeft:NO recurseRight:NO], NSStringFromSelector(_cmd));
}


@end