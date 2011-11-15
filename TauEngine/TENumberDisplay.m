//
//  TENumberDisplay.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENumberDisplay.h"
#import "TauEngine.h"


static GLKBaseEffect *digitsTextureEffect;

static CGSize digitSize;
static float digitFractionalWidth;

@implementation TENumberDisplay

@synthesize numDigits, decimalPointDigit, hiddenDigits;

+(void)initialize {
  UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:30];
  
  digitsTextureEffect = [TETexture effectWithTextureFromImage:[TEImage imageFromText:@"0123456789." withFont:font color:[UIColor whiteColor]]];
  digitsTextureEffect.texture2d0.envMode = GLKTextureEnvModeModulate;
  
  digitSize = [@"0" sizeWithFont:font];
  digitSize = CGSizeMake(digitSize.width-1.0, digitSize.height); // pads by 1 px on end
  digitFractionalWidth = digitSize.width / (11*digitSize.width + 1.0);
}

- (id)initWithNumDigits:(int)num
{
  self = [super initWithVertices:num*4];
  if (self) {
    effect = digitsTextureEffect;
    renderStyle = kTERenderStyleTexture | kTERenderStyleVertexColors;
    numDigits = num;
    decimalPointDigit = 0;
    hiddenDigits = 0;
    self.width = numDigits;
    self.number = 0;
  }
  
  return self;
}

-(void)updateVertices {
  float digitWidth = width / (numDigits-hiddenDigits);
  float digitHeight = digitSize.height * (digitWidth/digitSize.width);
  
  float offset = numDigits % 2 == 0 ? 0 : digitWidth / 2.0;
  int middle = (numDigits-hiddenDigits) / 2;
  float top = digitHeight/2;
  float bottom = -1*top;
  
  for (int i = 0; i < numDigits; i++) {
    int index = i*4;
    if (i < hiddenDigits) {
      self.vertices[index+0] = self.vertices[index+1] = self.vertices[index+2] = self.vertices[index+3] = GLKVector2Make(1000, 1000); // offscreen hack
    } else {
      float left = -1*(middle-(i-hiddenDigits))*digitWidth - offset;
      float right = left + digitWidth;
      self.vertices[index+0] = GLKVector2Make(left, top);
      self.vertices[index+1] = GLKVector2Make(left, bottom);
      self.vertices[index+2] = GLKVector2Make(right, top);
      self.vertices[index+3] = GLKVector2Make(right, bottom);
    }
  }
}

-(void)updateTextureCoordinates {
  for(int i = 0, temp = number; i < numDigits; ++i) {
    int index = (numDigits-i-1)*4;
    int digit;
    if (decimalPointDigit > 0 && i == decimalPointDigit)
      digit = 10;
    else {
      digit = temp-10*(temp/10);
      temp /= 10;
    }
    
    if (hiddenDigits > 0 && i >= hiddenDigits) {
      self.textureCoordinates[index+0] = self.textureCoordinates[index+1] = self.textureCoordinates[index+2] = self.textureCoordinates[index+3] = GLKVector2Make(0, 0);
    } else {
      self.textureCoordinates[index+0] = GLKVector2Make(digit*digitFractionalWidth, 1);
      self.textureCoordinates[index+1] = GLKVector2Make(digit*digitFractionalWidth, 0);
      self.textureCoordinates[index+2] = GLKVector2Make((digit+1)*digitFractionalWidth, 1);
      self.textureCoordinates[index+3] = GLKVector2Make((digit+1)*digitFractionalWidth, 0);
    }
    
    GLKVector4 digitColor = digit == 10 || ((digit == 0) && (temp <= 0)) ? GLKVector4Make(0.5,0.5,0.5,0.5) : GLKVector4Make(1,1,1,1);
    self.colorVertices[index+0] = self.colorVertices[index+1] = self.colorVertices[index+2] = self.colorVertices[index+3] = digitColor;
  }
}

-(GLenum)renderMode {
  return GL_TRIANGLE_STRIP;
}

-(int)number {
  return number;
}

-(void)setNumber:(int)_number {
  number = _number;
  [self updateTextureCoordinates];
}

-(float)height {
  return digitSize.height * ((width/(numDigits-hiddenDigits))/digitSize.width);
}

-(float)width {
  return width;
}

-(void)setWidth:(float)_width {
  width = _width;
  [self updateVertices];
}

@end
