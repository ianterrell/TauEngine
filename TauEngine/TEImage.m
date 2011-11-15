//
//  TEImage.m
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TEImage.h"

@implementation TEImage

+(UIImage *)imageFromText:(NSString *)text {
  return [self imageFromText:text withFont:[UIFont systemFontOfSize:20.0] color:[UIColor blackColor]];
}

+(UIImage *)imageFromText:(NSString *)text withFont:(UIFont *)font color:(UIColor *)color {
  CGSize size  = [text sizeWithFont:font];
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef contextRef =  CGBitmapContextCreate (NULL,
                                                    size.width, size.height,
                                                    8, 4*size.width,
                                                    colorSpace,
                                                    /* kCGBitmapByteOrder32Host for after beta5 */ kCGImageAlphaPremultipliedFirst
                                                    );
  CGColorSpaceRelease(colorSpace);
  UIGraphicsPushContext(contextRef);
  
  CGContextSetFillColorWithColor(contextRef, color.CGColor);
  [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
  UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(contextRef) scale:1.0 orientation:UIImageOrientationDownMirrored];
  
  UIGraphicsPopContext();
  
  return image;
}

@end
