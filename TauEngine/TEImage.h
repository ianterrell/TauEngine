//
//  TEImage.h
//  TauGame
//
//  Created by Ian Terrell on 7/28/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TEImage : NSObject

+(UIImage *)imageFromText:(NSString *)text;
+(UIImage *)imageFromText:(NSString *)text withFont:(UIFont *)font color:(UIColor *)color;

@end
