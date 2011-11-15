//
//  TENumberDisplay.h
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEPolygon.h"

@interface TENumberDisplay : TEPolygon {
  int number, numDigits, padDigit, decimalPointDigit, hiddenDigits;
  float width;
}

@property int number, numDigits, hiddenDigits, decimalPointDigit;
@property(readonly) float height;
@property float width;

-(id)initWithNumDigits:(int)num;

@end
