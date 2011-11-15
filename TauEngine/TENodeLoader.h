//
//  TENodeLoader.h
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENode.h"

@interface TENodeLoader : NSObject

+(void)loadCharacter:(TENode *)character fromJSONFile:(NSString *)fileName;
+(TENode *)loadCharacterFromJSONFile:(NSString *)fileName;

@end
