//
//  TERandomPolygon.h
//  TauGame
//
//  Created by Ian Terrell on 7/29/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEPolygon.h"

@interface TERandomPolygon : TEPolygon {
  int numSides;
  float lowerFactor, upperFactor;
}
@property int numSides;

-(id)initWithSides:(int)numSides lowerFactor:(float)lower upperFactor:(float)upper;

@end
