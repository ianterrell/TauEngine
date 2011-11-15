//
//  TESoundManager.m
//  TauGame
//
//  Created by Ian Terrell on 7/25/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TESoundManager.h"

@implementation TESoundManager

- (id)init
{
  self = [super init];
  if (self) {
    sounds = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

+(TESoundManager *)sharedManager {
  static TESoundManager *singleton;
  
  @synchronized(self) {
    if (!singleton)
      singleton = [[TESoundManager alloc] init];
    return singleton;
  }
}

-(void)load:(NSString *)filename {
  CFBundleRef mainBundle = CFBundleGetMainBundle();
  CFURLRef soundFileURLRef  = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)filename, CFSTR("wav"), NULL);
  SystemSoundID soundID;
  if (AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID) == kAudioServicesNoError)
    [sounds setObject:[NSNumber numberWithUnsignedInt:soundID] forKey:filename];
  else
    NSLog(@"Could not load sound '%@.wav'", filename); 
}

-(void)play:(NSString *)sound {
  NSNumber *soundID = (NSNumber *)[sounds objectForKey:sound];
  if (soundID != nil)
    AudioServicesPlaySystemSound([soundID unsignedIntValue]);
  else
    NSLog(@"Sound '%@.wav' has not been loaded.", sound);
}

@end
