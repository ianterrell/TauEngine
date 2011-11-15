//
//  TESoundManager.h
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

@interface TESoundManager : NSObject {
  NSMutableDictionary *sounds;
}

+(TESoundManager *)sharedManager;

-(void)load:(NSString *)filename;
-(void)play:(NSString *)sound;

@end
