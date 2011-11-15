//
//  TERandom.h
//  TauGame
//
//  Created by Ian Terrell on 7/26/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TERandom : NSObject

/*
 * Returns a random number in [0,0xFFFFFFFF]
 */
+(unsigned int)random;

/*
 * Returns a random number in [0,b)
 */
+(unsigned int)randomTo:(int)b;

/*
 * Returns a random number in [a,b)
 */
+(unsigned int)randomFrom:(int)a to:(int)b;

/*
 * Returns a random number in [1,n]
 */
+(unsigned int)rollDiceWithSides:(int)n;

/*
 * Returns a random double in [0,1)
 */
+(double)randomFraction;

/*
 * Returns a random double in [low,high)
 */
+(double)randomFractionFrom:(double)low to:(double)high;

@end
