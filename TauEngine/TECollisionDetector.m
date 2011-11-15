//
//  TECollisionDetector.m
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TECollisionDetector.h"
#import "TauEngine.h"

typedef enum {
  TECollisionTypePolygonPolygon,
  TECollisionTypePolygonCircle,
  TECollisionTypeCircleCircle,
  TECollisionTypePointPolygon,
  TECollisionTypePointCircle,
} TECollisionType;

typedef struct {
  float min;
  float max;
} ProjectionRange;

@implementation TECollisionDetector

#pragma mark - Object to World Coordinate Transformation

+(GLKVector2)transformedPoint:(GLKVector2)point fromShape:(TEShape*)shape {
  GLKVector4 transformedPoint = GLKMatrix4MultiplyVector4(shape.node.modelViewMatrix, GLKVector4Make(point.x,point.y,0,1));
  return GLKVector2Make(transformedPoint.x, transformedPoint.y);
}

#pragma mark - Collision detection between two circles

+(BOOL)circle:(TENode *)node1 collidesWithCircle:(TENode *)node2 {
  GLKVector2 circle1Center  = [self transformedPoint:GLKVector2Make(0,0) fromShape:(TEShape *)node1.drawable];
  GLKVector2 pointOnCircle1 = [self transformedPoint:GLKVector2Make(0,((TEShape *)node1.drawable).radius) fromShape:(TEShape *)node1.drawable];
  float radius1 = GLKVector2Length(GLKVector2Subtract(pointOnCircle1, circle1Center));
  
  GLKVector2 circle2Center  = [self transformedPoint:GLKVector2Make(0,0) fromShape:(TEShape *)node2.drawable];
  GLKVector2 pointOnCircle2 = [self transformedPoint:GLKVector2Make(0,((TEShape *)node2.drawable).radius) fromShape:(TEShape *)node2.drawable];
  float radius2 = GLKVector2Length(GLKVector2Subtract(pointOnCircle2, circle2Center));
  
  GLKVector2 difference = GLKVector2Subtract(circle1Center, circle2Center);
  float distance = GLKVector2Length(difference);
  return distance <= (radius1 + radius2);
  
  // TODO: test optimizations
  //  return (difference.x * difference.x + difference.y * difference.y) <= (radius1 + radius2) * (radius1 + radius2);
}

#pragma mark - Collision detection between two polygons

+(GLKVector2)axisPerpendicularToEdge:(GLKVector2)edge {
  return GLKVector2Normalize(GLKVector2Make(-edge.y,edge.x));
}

+(ProjectionRange)polygon:(TEPolygon *)poly projectedOnto:(GLKVector2)axis {
  ProjectionRange range;
  range.min = INFINITY;
  range.max = 0;
  
  for (int i = 0; i < poly.numVertices; i++) {
    float projection = GLKVector2DotProduct(poly.vertices[i], axis);
    range.min = MIN(range.min,projection);
    range.max = MAX(range.max,projection);
  }
  
  return range;
}

+(BOOL)polygon:(TEPolygon *)poly1 andPolygon:(TEPolygon *)poly2 intersectOnAxis:(GLKVector2)axis {
  ProjectionRange poly1Projection = [self polygon:poly1 projectedOnto:axis];
  ProjectionRange poly2Projection = [self polygon:poly2 projectedOnto:axis];
  
  if (poly1Projection.min <= poly2Projection.min)
    return poly2Projection.min <= poly1Projection.max;
  else
    return poly1Projection.min <= poly2Projection.max;
}

+(BOOL)testedEdge:(GLKVector2)edge alreadyTested:(GLKVector2[])edges numTested:(int)n {
  for (int i = 0; i < n; i++)
    if (GLKVector2AllEqualToVector2(edges[i],GLKVector2Negate(edge)) || GLKVector2AllEqualToVector2(edges[i],edge))
      return YES;
  return NO;
}

+(BOOL)intersectOnEdgesFirst:(TEPolygon *)poly1 second:(TEPolygon*)poly2 {
  GLKVector2 testedEdges[poly1.numEdges+poly2.numEdges];
  int testedCount = 0;
  for (int i = 0; i<2; i++){
    TEPolygon *poly = i == 0 ? poly1 : poly2;
    for (int j = 0; j < poly.numEdges; j++) {
      GLKVector2 edge = GLKVector2Subtract(poly.vertices[(j+1+poly.edgeVerticesOffset)%poly.numEdges], poly.vertices[j+poly.edgeVerticesOffset]);
      GLKVector2 perpendicularAxis = [self axisPerpendicularToEdge:edge];

      if (![self testedEdge:perpendicularAxis alreadyTested:testedEdges numTested:testedCount]) {      
        if (![self polygon:poly1 andPolygon:poly2 intersectOnAxis:perpendicularAxis])
          return NO;
        else
          testedEdges[testedCount++] = edge;
      }
    }
  }
  return YES;
}

+(TEPolygon *)transformedPolygonFrom:(TEPolygon *)drawable {
  TEPolygon *poly = [[TEPolygon alloc] initWithVertices:drawable.numVertices];
  for (int i = 0; i < poly.numVertices; i++)
    poly.vertices[i] = [self transformedPoint:drawable.vertices[i] fromShape:drawable];
  return poly;
}

+(BOOL)polygon:(TENode *)node1 collidesWithPolygon:(TENode *)node2 {
  // Check bounding circles first; way faster
  if (![self circle:node1 collidesWithCircle:node2])
    return NO;
  
  // Transform our polygons
  TEPolygon *poly1 = [self transformedPolygonFrom:((TEPolygon *)node1.drawable)];
  TEPolygon *poly2 = [self transformedPolygonFrom:((TEPolygon *)node2.drawable)];
  
  // Test by separating axis theorem
  return [self intersectOnEdgesFirst:poly1 second:poly2];
}

# pragma mark - Collision detection between point and polygon

+(BOOL)point:(GLKVector2)point collidesWithPolygon:(TENode *)node {
  if (![node.shape isKindOfClass:[TERectangle class]]) {
    NSLog(@"Point/GenericPolygon collisions not yet implemented. Only rectangles!");
    return NO;
  }
  
  TEPolygon *rectangle = [self transformedPolygonFrom:((TEPolygon *)node.drawable)];
  return point.x >= rectangle.vertices[kTERectangleBottomLeft].x && point.x <= rectangle.vertices[kTERectangleTopRight].x && 
         point.y >= rectangle.vertices[kTERectangleBottomLeft].y && point.y <= rectangle.vertices[kTERectangleTopRight].y;
}

# pragma mark - Collision detection between point and circle

+(BOOL)point:(GLKVector2)point collidesWithCircle:(TENode *)node {
  GLKVector2 circleCenter  = [self transformedPoint:GLKVector2Make(0,0) fromShape:(TEShape *)node.drawable];
  GLKVector2 pointOnCircle = [self transformedPoint:GLKVector2Make(0,((TEShape *)node.drawable).radius) fromShape:(TEShape *)node.drawable];
  float radius = GLKVector2Length(GLKVector2Subtract(pointOnCircle, circleCenter));

  GLKVector2 difference = GLKVector2Subtract(circleCenter, point);
  float distance = GLKVector2Length(difference);
  return distance <= radius;
  
  // TODO: test optimizations
  //  return (difference.x * difference.x + difference.y * difference.y) <= (radius1 + radius2) * (radius1 + radius2);
}

# pragma mark - Collision detection between nodes

+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 type:(TECollisionType)type {
  if (type == TECollisionTypePolygonPolygon) {
    return [self polygon:node1 collidesWithPolygon:node2];
  } else if (type == TECollisionTypePolygonCircle) {
    NSLog(@"Polygon/Circle collision detection not yet implemented");
    // TODO! http://stackoverflow.com/questions/1073336/circle-line-collision-detection
    return NO;
  } else {
    return [self circle:node1 collidesWithCircle:node2];
  }
}


+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 {
  if (!node1.collide || !node2.collide || node1.drawable == nil || node2.drawable == nil) {
    return NO;
  } else {
    if ([(TEShape *)node1.drawable isPolygon]) {
      if ([(TEShape *)node2.drawable isPolygon])
        return [self node:node1 collidesWithNode:node2 type:TECollisionTypePolygonPolygon];
      else
        return [self node:node1 collidesWithNode:node2 type:TECollisionTypePolygonCircle];
    } else {
      if ([(TEShape *)node2.drawable isPolygon])
        return [self node:node2 collidesWithNode:node1 type:TECollisionTypePolygonCircle];
      else
        return [self node:node1 collidesWithNode:node2 type:TECollisionTypeCircleCircle];
    }
  }
}

+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight {
  __block BOOL collision = NO;
  
  if (recurseLeft) {
    [node1 traverseUsingBlock:^(TENode *leftNode) {
      if (recurseRight) {
        [node2 traverseUsingBlock:^(TENode *rightNode) {
          if (!collision && [self node:leftNode collidesWithNode:rightNode]) // TODO: no need for !collision if we had a BOOL* break in traverseUsingBlock:
            collision = YES;
        }];
      } else {
        if (!collision && [self node:leftNode collidesWithNode:node2])
          collision = YES;
      }
    }];
  } else {
    if (recurseRight) {
      [node2 traverseUsingBlock:^(TENode *rightNode) {
        if (!collision && [self node:node1 collidesWithNode:rightNode])
          collision = YES;
      }];
    } else {
      if (!collision && [self node:node1 collidesWithNode:node2])
        collision = YES;
    }
  }

  return collision;
}

# pragma mark - Collision detection between a point and a node

+(BOOL)point:(GLKVector2)point collidesWithNode:(TENode *)node type:(TECollisionType)type {
  if (type == TECollisionTypePointPolygon)
    return [self point:point collidesWithPolygon:node];
  else
    return [self point:point collidesWithCircle:node];
}

+(BOOL)point:(GLKVector2)point collidesWithNode:(TENode *)node {
  if (!node.collide || node.drawable == nil) {
    return NO;
  } else {
    if ([(TEShape *)node.drawable isPolygon])
      return [self point:point collidesWithNode:node type:TECollisionTypePointPolygon];
    else
      return [self point:point collidesWithNode:node type:TECollisionTypePointCircle];
  }
}

+(BOOL)point:(GLKVector2)point collidesWithNode:(TENode *)node recurseNode:(BOOL)recurseNode {
  __block BOOL collision = NO;
  
  if (recurseNode) {
    [node traverseUsingBlock:^(TENode *rightNode) {
      if (!collision && [self point:point collidesWithNode:rightNode])
        collision = YES;
    }];
  } else {
    if (!collision && [self point:point collidesWithNode:node])
      collision = YES;
  }
  
  return collision;
}

# pragma mark - Collision detection within an array

+(NSMutableArray *)collisionsIn:(NSArray *)nodes {
  return [self collisionsIn:nodes maxPerNode:0];
}
                                
+(NSMutableArray *)collisionsIn:(NSArray *)nodes maxPerNode:(int)n {
  NSMutableArray *collisions = [[NSMutableArray alloc] init];
  [self collisionsIn:nodes maxPerNode:n withBlock:^(TENode *node1, TENode *node2) {
    [collisions addObject:[[NSArray alloc] initWithObjects:node1, node2, nil]];
  }];
  return collisions;
}

+(void)collisionsIn:(NSArray *)nodes withBlock:(void (^)(TENode *, TENode *))block {
  return [self collisionsIn:nodes maxPerNode:0 withBlock:block];
}

+(void)collisionsIn:(NSArray *)nodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  [self collisionsIn:nodes recurseLeft:NO recurseRight:NO maxPerNode:n withBlock:block];
}

+(void)collisionsIn:(NSArray *)nodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  int size = [nodes count];
  for (int i = 0; i < size; i++) {
    int count = 0;
    for (int j = i + 1; j < size; j++) {
      TENode *node1 = (TENode *)[nodes objectAtIndex:i];
      TENode *node2 = (TENode *)[nodes objectAtIndex:j];
      if ([self node:node1 collidesWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight]) {
        block(node1,node2);
        if (n > 0 && ++count >= n)
          break;
      }
    }
  }
}

# pragma mark - Collision detection between two arrays

+(NSMutableArray *)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes {
  return [self collisionsBetween:nodes andNodes:moreNodes maxPerNode:0];
}

+(NSMutableArray *)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes maxPerNode:(int)n {
  NSMutableArray *collisions = [[NSMutableArray alloc] init];
  [self collisionsBetween:nodes andNodes:moreNodes maxPerNode:n withBlock:^(TENode *node1, TENode *node2) {
    [collisions addObject:[[NSArray alloc] initWithObjects:node1, node2, nil]];
  }];
  return collisions;
}

+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes withBlock:(void (^)(TENode *, TENode *))block {
  [self collisionsBetween:nodes andNodes:moreNodes maxPerNode:0 withBlock:block];
}

+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  [self collisionsBetween:nodes andNodes:moreNodes recurseLeft:NO recurseRight:NO maxPerNode:n withBlock:block];
}

+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  for (TENode *node1 in nodes) {
    int count = 0;
    for (TENode *node2 in moreNodes) {
      if ([self node:node1 collidesWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight]) {
        block(node1,node2);
        if (n > 0 && ++count >= n)
          break;
      }
    }
  }
}

# pragma mark - Collision detection between a node and an array

+(NSMutableArray *)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes {
  return [self collisionsBetweenNode:node andNodes:moreNodes maxPerNode:0];
}

+(NSMutableArray *)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes maxPerNode:(int)n {
  NSMutableArray *collisions = [[NSMutableArray alloc] init];
  [self collisionsBetweenNode:node andNodes:moreNodes maxPerNode:n withBlock:^(TENode *node1, TENode *node2) {
    [collisions addObject:[[NSArray alloc] initWithObjects:node1, node2, nil]];
  }];
  return collisions;
}

+(void)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes withBlock:(void (^)(TENode *, TENode *))block {
  return [self collisionsBetweenNode:node andNodes:moreNodes maxPerNode:0 withBlock:block];
}

+(void)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  [self collisionsBetweenNode:node andNodes:moreNodes recurseLeft:NO recurseRight:NO maxPerNode:n withBlock:block];
}

+(void)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block {
  int count = 0;
  for (TENode *node2 in moreNodes) {
    if ([self node:node collidesWithNode:node2 recurseLeft:recurseLeft recurseRight:recurseRight]) {
      block(node,node2);
      if (n > 0 && ++count >= n)
        break;
    }
  }
}


@end
