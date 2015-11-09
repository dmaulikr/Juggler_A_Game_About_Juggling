//
//  GameOverScene.h
//  Juggler
//
//  Created by Evan Lewis on 5/30/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

@property BOOL contentCreated;

-(void)sendScore:(int)score;

@end
