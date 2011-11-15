//
//  TERandom.m
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TERandom.h"

#define ARC4RANDOM_MAX UINT32_MAX

@implementation TERandom

+(unsigned int)random {
  return arc4random();
}

+(unsigned int)randomTo:(int)b {
  return [self random] % b;
}

+(unsigned int)randomFrom:(int)a to:(int)b {
  return a + [self randomTo:(b-a)];
}

+(unsigned int)rollDiceWithSides:(int)n {
  return [self randomFrom:1 to:(n+1)];
}

+(double)randomFraction {
  return (double)[self random]/ARC4RANDOM_MAX; 
}

+(double)randomFractionFrom:(double)low to:(double)high {
  return ([self randomFraction] * (high - low)) + low;
}

@end
