//
//  TECollisionDetector.h
//  TauGame
//
//  Created by Ian Terrell on 7/13/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TauEngine.h"

@interface TECollisionDetector : NSObject

# pragma mark - Collision detection between nodes

+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2;
+(BOOL)node:(TENode *)node1 collidesWithNode:(TENode *)node2 recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight;

# pragma mark - Collision detection between a point and a node

+(BOOL)point:(GLKVector2)point collidesWithNode:(TENode *)node;
+(BOOL)point:(GLKVector2)point collidesWithNode:(TENode *)node recurseNode:(BOOL)recurseNode;

# pragma mark - Collision detection within an array

+(NSMutableArray *)collisionsIn:(NSArray *)nodes;
+(NSMutableArray *)collisionsIn:(NSArray *)nodes maxPerNode:(int)n;
+(void)collisionsIn:(NSArray *)nodes withBlock:(void (^)(TENode *, TENode *))block;
+(void)collisionsIn:(NSArray *)nodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block;
+(void)collisionsIn:(NSArray *)nodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block;

# pragma mark - Collision detection between two arrays

+(NSMutableArray *)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes;
+(NSMutableArray *)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes maxPerNode:(int)n;
+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes withBlock:(void (^)(TENode *, TENode *))block;
+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block;
+(void)collisionsBetween:(NSArray *)nodes andNodes:(NSArray *)moreNodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block;

# pragma mark - Collision detection between a node and an array

+(NSMutableArray *)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes;
+(NSMutableArray *)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes maxPerNode:(int)n;
+(void)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes withBlock:(void (^)(TENode *, TENode *))block;
+(void)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block;
+(void)collisionsBetweenNode:(TENode *)node andNodes:(NSArray *)moreNodes recurseLeft:(BOOL)recurseLeft recurseRight:(BOOL)recurseRight maxPerNode:(int)n withBlock:(void (^)(TENode *, TENode *))block;


@end
