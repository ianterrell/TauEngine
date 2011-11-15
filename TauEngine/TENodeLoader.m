//
//  TENodeLoader.m
//  TauGame
//
//  Created by Ian Terrell on 7/12/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "TENodeLoader.h"
#import "TauEngine.h"

@implementation TENodeLoader

+(void)parseTransformsForNode:(TENode *)node attributes:(NSDictionary *)attributes {
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    // Scale
    if ([key isEqualToString:@"scale"]) {
      node.scale = [obj floatValue];
    } 
    else if ([key isEqualToString:@"scaleX"]) {
      node.scaleX = [obj floatValue];
    } 
    else if ([key isEqualToString:@"scaleY"]) {
      node.scaleY = [obj floatValue];
    } 
    
    // Translation
    else if ([key isEqualToString:@"translation"]) {
      node.position = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
    } 
    
    // Rotation
    else if ([key isEqualToString:@"rotation"]) {
      node.rotation = [obj floatValue];
    }
  }];
}

+(TEShape *)createShape:(NSDictionary *)attributes {
  NSString *geometry = [attributes objectForKey:@"geometry"];
  TEShape *shape;
  if ([geometry isEqualToString:@"triangle"]) {
    shape = [[TETriangle alloc] init];
  } else if ([geometry isEqualToString:@"square"] || [geometry isEqualToString:@"rectangle"]) {
    shape = [[TERectangle alloc] init];
  } else if ([geometry isEqualToString:@"circle"] || [geometry isEqualToString:@"ellipse"]) {
    shape = [[TEEllipse alloc] init];
  } else if ([geometry isEqualToString:@"polygon"]) {
    shape = [[TEPolygon alloc] initWithVertices:[[attributes objectForKey:@"num-vertices"] intValue]];
  } else if ([geometry isEqualToString:@"hexagon"]) {
    shape = [[TEHexagon alloc] init];
  } else if ([geometry isEqualToString:@"heptagon"]) {
    shape = [[TEHeptagon alloc] init];
  } else if ([geometry isEqualToString:@"octagon"]) {
    shape = [[TEOctagon alloc] init];
  } else {
    NSLog(@"Unrecognized shape: '%@'", geometry);
    return nil;
  }

  [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
    // Set constant color
    if ([key isEqualToString:@"color"]) {
      shape.color = GLKVector4Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue], 
                                   [[obj objectAtIndex:2] floatValue], [[obj objectAtIndex:3] floatValue]);
    } 
    
    // Set vertex colors & adjust render style
    else if ([key length] == 6 && [[key substringToIndex:5] isEqualToString:@"color"]) {
      shape.renderStyle = kTERenderStyleVertexColors;
      ((TEPolygon *)shape).colorVertices[[[key substringWithRange:NSMakeRange(5,1)] intValue]] = GLKVector4Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue], 
                                                                                                                [[obj objectAtIndex:2] floatValue], [[obj objectAtIndex:3] floatValue]);
    } 
    
    // Set vertex data
    else if ([key length] == 7 && [[key substringToIndex:6] isEqualToString:@"vertex"]) {
      ((TEPolygon *)shape).vertices[[[key substringWithRange:NSMakeRange(6,1)] intValue]] = GLKVector2Make([[obj objectAtIndex:0] floatValue], [[obj objectAtIndex:1] floatValue]);
    } 
    
    // Set data for rectangles
    else if ([key isEqualToString:@"height"]) {
      ((TERectangle *)shape).height = [obj floatValue];
    } else if ([key isEqualToString:@"width"]) {
      ((TERectangle *)shape).width = [obj floatValue];
    } 
    
    // Set radii
    else if ([key isEqualToString:@"radius"]) {
      [(id)shape setRadius:[obj floatValue]];
    } else if ([key isEqualToString:@"radiusX"]) {
      ((TEEllipse *)shape).radiusX = [obj floatValue];
    } else if ([key isEqualToString:@"radiusY"]) {
      ((TEEllipse *)shape).radiusY = [obj floatValue];
    } 
  }];
  return shape;
}

+(void)setUpColliders:(TENode *)node attributes:(NSDictionary *)attributes {
  NSString *collide = (NSString *)[attributes objectForKey:@"collide"];
  if ([collide isEqualToString:@"yes"])
    node.collide = YES;
}

+(void)parseNode:(TENode *)node attributes:(NSDictionary *)attributes {
  [self setUpColliders:node attributes:attributes];
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [self parseTransformsForNode:node attributes:attributes];
    if ([key isEqualToString:@"shape"]) {
      TEShape *shape = [self createShape:obj];
      node.drawable = shape;
      shape.node = node;
    } else if ([key isEqualToString:@"children"]) {
      [obj enumerateKeysAndObjectsUsingBlock:^(id childName, id childAttributes, BOOL *stop) {
        TENode *childNode = [[TENode alloc] init];
        childNode.name = childName;
        [self parseNode:childNode attributes:childAttributes];
        [node addChild:childNode];
      }];
    }
  }];
}

+(void)loadCharacter:(TENode *)character fromJSONFile:(NSString *)fileName {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  
  NSError *error;
  NSDictionary *characterData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (!characterData) {
    NSLog(@"Could not load character data, error is %@", error);
    return;
  }
  
  character.name = [[characterData allKeys] objectAtIndex:0];
  [self parseNode:character attributes:[characterData objectForKey:character.name]];
}

+(TENode *)loadCharacterFromJSONFile:(NSString *)fileName {
  TENode *character = [[TENode alloc] init];
  [self loadCharacter:character fromJSONFile:fileName];
  return character;
}

   
@end
