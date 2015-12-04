//
//  Item.h
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

@import SpriteKit;

@interface Item : SKNode

- (SKNode*)addRandomItem:(CGSize)size;
- (void)initPhysics;
- (SKNode*)ball;

@property (nonatomic, assign) BOOL isMainMenu;

@end
