//
//  MainMenuScene.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameCenterControl.h"
#import "JugglerViewController.h"
#import "GameScene.h"
#import "Item.h"
#import "Chartboost.h"

static int deviceMult;

@interface MainMenuScene () {
  AudioSession* audioSession;
  NSTimer* timer;
  NSTimer* ballTimer;
  Item* item;
  int cloudCounter;
  int zIndex;
  float middleNodePositionX;
  float middleNodePositionY;
  SKSpriteNode *soundNode;
}

@property BOOL contentCreated;

@end


@implementation MainMenuScene

- (void)didMoveToView: (SKView *) view {
  if (!self.contentCreated) {
    [self createSceneContents];
    self.contentCreated = YES;
  }
}

- (void)createSceneContents {
  audioSession = [[AudioSession alloc] init];
  if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    deviceMult = 2;
  } else {
    deviceMult = 1;
  }
  
  middleNodePositionX = self.frame.size.width/2;
  middleNodePositionY = self.frame.size.height/4.1;
  zIndex = 100;
  cloudCounter = 0;
  self.backgroundColor = [SKColor colorWithRed: 0.388 green: 0.851 blue: 0.855 alpha: 1];
  self.scaleMode = SKSceneScaleModeAspectFit;
  item = [[Item alloc]init];
  [item setIsMainMenu:YES];
  timer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                           target:self
                                         selector:@selector(updateWithTimer:)
                                         userInfo:nil
                                          repeats:YES];
  ballTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                               target:self
                                             selector:@selector(updateBallWithTimer:)
                                             userInfo:nil
                                              repeats:YES];
  
  [self addCloud];
  [self addChild:[self newTitleNode]];
  [self addChild:[self newBeginNode]];
  [self addChild:[self newScoreNode]];
  [self addChild:[self newSoundNode]];
}

- (void)launchItem {
  [self addChild:[item addRandomItem:self.size]];
  [item initPhysics];
}

- (void)toggleSound {
  if(![audioSession toggleAudioSettings]) {
    [soundNode setAlpha:0.5];
  } else {
    [soundNode setAlpha:1];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"Begin"]) {
      [self change:(SKSpriteNode*)node to:@"Begin-Button-Selected"];
      [self runAction:[audioSession playSound:@"Click_Down.mp3"]];
    } else if ([node.name isEqualToString:@"Score"]) {
      [self change:(SKSpriteNode*)node to:@"Leaderboard-Button-Selected"];
      [self runAction:[audioSession playSound:@"Click_Down.mp3"]];
    } else if ([node.name isEqualToString:@"Sound"]) {
      [self change:(SKSpriteNode*)node to:@"Sound-Button-Selected"];
    } else if ([node.name isEqualToString:@"More"]) {
      [self change:(SKSpriteNode*)node to:@"More-Games-Button-Selected"];
      [self runAction:[audioSession playSound:@"Click_Down.mp3"]];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"Begin"]) {
      [self change:(SKSpriteNode*)node to:@"Begin-Button"];
    } else if ([node.name isEqualToString:@"Score"]) {
      [self change:(SKSpriteNode*)node to:@"Leaderboard-Button"];
    } else if ([node.name isEqualToString:@"Sound"]) {
      [self change:(SKSpriteNode*)node to:@"Sound-Button"];
    }
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"Begin"]) {
      [self change:(SKSpriteNode*)node to:@"Begin-Button"];
      [self runAction:[audioSession playSound:@"Click_Up.mp3"]];
      [timer invalidate]; timer = nil;
      [ballTimer invalidate]; ballTimer = nil;
      GameScene *gameScene  = [[GameScene alloc] initWithSize:self.size];
      [self.view presentScene:gameScene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:1.0]];
    } else if ([node.name isEqualToString:@"Score"]) {
      [self change:(SKSpriteNode*)node to:@"Leaderboard-Button"];
      [self runAction:[audioSession playSound:@"Click_Up.mp3"]];
      JugglerViewController* vc = [[JugglerViewController alloc] init];
      [vc showGameCenterLeaderboard];
    } else if ([node.name isEqualToString:@"Sound"]) {
      [self change:(SKSpriteNode*)node to:@"Sound-Button"];
      [self toggleSound];
    }
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"Begin"]) {
      [self change:(SKSpriteNode*)node to:@"Begin-Button"];
    } else if ([node.name isEqualToString:@"Score"]) {
      [self change:(SKSpriteNode*)node to:@"Leaderboard-Button"];
    } else if ([node.name isEqualToString:@"Sound"]) {
      [self change:(SKSpriteNode*)node to:@"Sound-Button"];
    }
  }
}

- (SKLabelNode *)newTitleNode {
  SKLabelNode *titleNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
  titleNode.text = @"Juggler";
  titleNode.name = @"Title";
  titleNode.fontSize = 76 * deviceMult;
  titleNode.zPosition = zIndex;
  titleNode.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height/1.3);
  return titleNode;
}

- (SKSpriteNode*)newBeginNode {
  SKSpriteNode *beginNode = [SKSpriteNode spriteNodeWithImageNamed:@"Begin-Button"];
  beginNode.name = @"Begin";
  beginNode.zPosition = zIndex;
  beginNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  return beginNode;
}

- (SKSpriteNode*)newScoreNode {
  SKSpriteNode *scoreNode = [SKSpriteNode spriteNodeWithImageNamed:@"Leaderboard-Button"];
  scoreNode.name = @"Score";
  scoreNode.zPosition = zIndex;
  scoreNode.position = CGPointMake(middleNodePositionX - (self.frame.size.width/6.38509316770186), middleNodePositionY);
  return scoreNode;
}

- (SKSpriteNode*)newSoundNode {
  soundNode = [SKSpriteNode spriteNodeWithImageNamed:@"Sound-Button"];
  soundNode.name = @"Sound";
  soundNode.zPosition = zIndex;
  soundNode.position = CGPointMake(middleNodePositionX + (self.frame.size.width/6.38509316770186), middleNodePositionY);
  if (!audioSession.isAudioSessionActive) {
    soundNode.alpha = 0.5;
  }
  return soundNode;
}

- (void)change:(SKSpriteNode*)node to:(NSString*)newImage {
  SKAction* changeImage = [SKAction setTexture:[SKTexture textureWithImageNamed:newImage]];
  [node runAction:changeImage];
}

- (void)updateWithTimer:(NSTimer*)timer {
  if (cloudCounter <= 3) {
    [self addCloud];
  }
}

- (void)updateBallWithTimer:(NSTimer*)timer {
  [self launchItem];
}

- (void)didSimulatePhysics {
  [self enumerateChildNodesWithName:@"item" usingBlock:^(SKNode *node, BOOL *stop) {
    if (node.position.y < 0) {
      [node removeFromParent];
    }
  }];
}

- (void)addCloud {
  cloudCounter++;
  NSArray* cloudArray = @[@"Cloud1", @"Cloud2", @"Cloud3"];
  SKSpriteNode* cloud = [[SKSpriteNode alloc] initWithImageNamed:[cloudArray objectAtIndex:arc4random() % [cloudArray count]]];
  cloud.position = CGPointMake((0 - cloud.frame.size.width), ((double)arc4random() / ARC4RANDOM_MAX) * ((self.size.height) - (0)) + (0));
  cloud.name = @"Cloud";
  cloud.zPosition = zIndex - 10;
  [self addChild:cloud];
  [cloud runAction:[SKAction moveToX:self.size.width + cloud.size.width duration:((double)arc4random() / ARC4RANDOM_MAX) * ((40.0f) - (15.0f)) + (15.0f)] completion:^{
    [cloud removeFromParent];
    cloudCounter--;
  }];
}

@end
