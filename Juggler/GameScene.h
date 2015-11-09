//
//  GameScene.h
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, assign) BOOL inGame;
-(void)pauseGame;

@end
