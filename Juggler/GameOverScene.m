//
//  GameOverScene.m
//  Juggler
//
//  Created by Evan Lewis on 5/30/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "Score.h"
#import <Chartboost/Chartboost.h>

@interface GameOverScene () {
  Score* score;
  int cloudCounter;
  NSTimer* cloudTimer;
  AudioSession* audioSession;
  
#pragma mark iPad
  int deviceMulti;
  CGPoint trophyLocation;
  float trophyScale;
  CGPoint highScoreLabelPosition;
  CGPoint scorePosition;
}

@property int gameScore;

@end

@implementation GameOverScene

-(void)didMoveToView:(SKView *)view {
  if (!self.contentCreated) {
    [self createSceneContents];
    self.contentCreated = YES;
  }
}

-(void)createSceneContents {
  audioSession = [[AudioSession alloc] init];
  if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    deviceMulti = 2;
    highScoreLabelPosition = CGPointMake(self.size.width/1.8, self.size.height/1.6);
    trophyLocation = CGPointMake(highScoreLabelPosition.x - self.size.width/9, self.size.height/1.548);
    scorePosition = CGPointMake(self.size.width/2, self.size.height/1.4);
    trophyScale = 0.3;
  } else {
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
      deviceMulti = 1;
      highScoreLabelPosition = CGPointMake(self.size.width/1.8, self.size.height/1.74);
      trophyLocation = CGPointMake(highScoreLabelPosition.x - self.size.width/8, self.size.height/1.68);
      scorePosition = CGPointMake(self.size.width/2, self.size.height/1.45);
      trophyScale = 0.5;
    } else {
      deviceMulti = 1;
      highScoreLabelPosition = CGPointMake(self.size.width/1.8, self.size.height/1.74);
      trophyLocation = CGPointMake(highScoreLabelPosition.x - self.size.width/8, self.size.height/1.66);
      scorePosition = CGPointMake(self.size.width/2, self.size.height/1.48);
      trophyScale = 0.5;
    }
    
  }
  
  self.backgroundColor = [SKColor colorWithRed: 0.388 green: 0.851 blue: 0.855 alpha: 1];
  score = [[Score alloc] init];
  [self addChild:[self newRestartLabel]];
  [self addChild:[self newMenuLabel]];
  [self addChild:[self newRateLabel]];
  [self addChild:[self newScoreLabel]];
  if ([score getHighScore] != 0) {
    [self addChild:[self newHighScoreLabel]];
  }
  if ([score getScore] > [score getHighScore]) {
    [self runAction:[audioSession playSound:@"Brrringgg.caf"]];
  }
  if ([score getScore] > 20) {
    [Chartboost showInterstitial:CBLocationGameOver];
  }
  cloudCounter = 0;
  self.gameScore = 0;
  [self addCloud];
  cloudTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                target:self
                                              selector:@selector(updateWithTimer:)
                                              userInfo:nil
                                               repeats:YES];
}

-(void)sendScore:(int)sentScore {
  self.gameScore = sentScore;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* nodeAtLocation = [self nodeAtPoint:location];
    if ([nodeAtLocation.name isEqualToString:@"restart"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Restart-Button-Selected"];
      [self runAction:[audioSession playSound:@"Click_Down.mp3"]];
    }
    if ([nodeAtLocation.name isEqualToString:@"menu"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Menu-Button-Selected"];
      [self runAction:[audioSession playSound:@"Click_Down.mp3"]];
    }
    if ([nodeAtLocation.name isEqualToString:@"rate"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Rate-Button-Selected"];
      [self runAction:[audioSession playSound:@"Click_Down.mp3"]];
    }
  }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* nodeAtLocation = [self nodeAtPoint:location];
    if ([nodeAtLocation.name isEqualToString:@"restart"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Restart-Button"];
    }
    if ([nodeAtLocation.name isEqualToString:@"menu"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Menu-Button"];
    }
    if ([nodeAtLocation.name isEqualToString:@"rate"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Rate-Button"];
    }
  }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* nodeAtLocation = [self nodeAtPoint:location];
    if ([nodeAtLocation.name isEqualToString:@"restart"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Restart-Button"];
      [self runAction:[audioSession playSound:@"Click_Up.mp3"]];
      [cloudTimer invalidate]; cloudTimer = nil;
      GameScene* gameScene = [[GameScene alloc] initWithSize:self.size];
      [self.view presentScene:gameScene transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.6f]];
    }
    if ([nodeAtLocation.name isEqualToString:@"menu"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Menu-Button"];
      [self runAction:[audioSession playSound:@"Click_Up.mp3"]];
      [cloudTimer invalidate]; cloudTimer = nil;
      MainMenuScene* menuScene = [[MainMenuScene alloc] initWithSize:self.size];
      [self.view presentScene:menuScene transition:[SKTransition pushWithDirection:SKTransitionDirectionDown duration:0.6f]];
    }
    if ([nodeAtLocation.name isEqualToString:@"rate"]) {
      [self change:(SKSpriteNode*)nodeAtLocation to:@"Rate-Button"];
      [self runAction:[audioSession playSound:@"Click_Up.mp3"]];
      [self rate];
    }
  }
}

-(SKLabelNode*)newScoreLabel {
  SKLabelNode* label = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica Neue"];
  
  if (self.gameScore % 100000 != self.gameScore) {
    label.fontSize = 80 * deviceMulti;
  } else if (self.gameScore % 10000 != self.gameScore) {
    label.fontSize = 120 * deviceMulti;
  } else if (self.gameScore % 1000 != self.gameScore) {
    label.fontSize = 160 * deviceMulti;
  }else {
    label.fontSize = 200 * deviceMulti;
  }
  label.text = [NSString stringWithFormat:@"%i", self.gameScore];
  label.position = scorePosition;
  label.zPosition = 90;
  [label setFontColor:[SKColor colorWithRed: 0.52 green: 0.52 blue: 0.52 alpha: 1]];
  
  return label;
}

-(SKLabelNode*)newHighScoreLabel {
  SKLabelNode* label = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica Neue"];
  label.text = [NSString stringWithFormat:@"%i", [score getHighScore]];
  label.fontSize = 32 * deviceMulti;
  label.position = highScoreLabelPosition;
  label.zPosition = 90;
  [label setFontColor:[SKColor colorWithRed: 1 green: 0.894 blue: 0 alpha: 1]];
  
  SKSpriteNode* trophy = [[SKSpriteNode alloc]initWithImageNamed:@"Trophy"];
  trophy.position = trophyLocation;
  trophy.zPosition = 90;
  trophy.xScale = trophyScale;
  trophy.yScale = trophyScale;
  [self addChild:trophy];
  
  return label;
}

-(SKSpriteNode*)newRestartLabel {
  SKSpriteNode* restartLabel = [[SKSpriteNode alloc]initWithImageNamed:@"Restart-Button"];
  restartLabel.name = @"restart";
  restartLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/2.3);
  restartLabel.zPosition = 101;
  return restartLabel;
}

-(SKSpriteNode*)newMenuLabel {
  SKSpriteNode* menuLabel = [[SKSpriteNode alloc]initWithImageNamed:@"Menu-Button"];
  menuLabel.name = @"menu";
  menuLabel.position = CGPointMake(self.frame.size.width/6, self.frame.size.height/4);
  menuLabel.zPosition = 101;
  return menuLabel;
}

-(SKSpriteNode*)newRateLabel {
  SKSpriteNode* rateLabel = [[SKSpriteNode alloc]initWithImageNamed:@"Rate-Button"];
  rateLabel.name = @"rate";
  rateLabel.position = CGPointMake(self.frame.size.width/1.2, self.frame.size.height/4);
  rateLabel.zPosition = 101;
  return rateLabel;
}

- (void)addCloud {
  cloudCounter++;
  NSArray* cloudArray = @[@"Cloud1", @"Cloud2", @"Cloud3"];
  SKSpriteNode* cloud = [[SKSpriteNode alloc] initWithImageNamed:[cloudArray objectAtIndex:arc4random() % [cloudArray count]]];
  cloud.position = CGPointMake((0 - cloud.frame.size.width), ((double)arc4random() / ARC4RANDOM_MAX) * ((self.size.height) - (0)) + (0));
  cloud.name = @"Cloud";
  cloud.zPosition = 70;
  [self addChild:cloud];
  [cloud runAction:[SKAction moveToX:self.size.width + cloud.size.width duration:((double)arc4random() / ARC4RANDOM_MAX) * ((40.0f) - (15.0f)) + (15.0f)] completion:^{
    [cloud removeFromParent];
    cloudCounter--;
  }];
}

- (void)change:(SKSpriteNode*)node to:(NSString*)newImage {
  SKAction* changeImage = [SKAction setTexture:[SKTexture textureWithImageNamed:newImage]];
  [node runAction:changeImage];
}

-(void)updateWithTimer:(NSTimer*)timer {
  if (cloudCounter <= 3) {
    [self addCloud];
  }
}

-(void)update:(NSTimeInterval)currentTime {
  if (self.view.paused) {
    self.view.paused = NO;
  }
}

-(void)rate {
  NSString * appId = @"881172212";
  NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
  if ([[UIDevice currentDevice].systemVersion integerValue] == 7) theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}

@end
