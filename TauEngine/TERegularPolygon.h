//
//  TERegularPolygon.h
//  TauGame
//
//  Created by Ian Terrell on 7/27/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEPolygon.h"

@interface TERegularPolygon : TEPolygon {
  int numSides;
}

@property float radius;

-(id)initWithSides:(int)numSides;

@end
