//
//  Item.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "Item.h"
static const uint32_t itemCategory = 0x1 << 0;
static const uint32_t fingerCategory = 0x1 << 1;

@interface Item () {
  SKNode* item;
  NSMutableArray* objectArray;
  float bowlingBallRadius;
  int randomItemsAdded;
  int counter;
  
#pragma mark iPad
  int ballLaunchSpeedXMenu;
  int ballLaunchSpeedYMenu;
  int ballLaunchSpeedXGame;
  int ballLaunchSpeedYGame;
  float ballRadius;
  int deviceMulti;
}

@end

@implementation Item

-(id)init {
  if (self = [super init]) {
    objectArray = [[NSMutableArray alloc] init];
    randomItemsAdded = 0;
    counter = 0;
    item = [[SKNode alloc]init];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
      ballLaunchSpeedXMenu = 10.16;
      ballLaunchSpeedYMenu = 72.4;
      ballLaunchSpeedXGame = 8.8;
      ballLaunchSpeedYGame = 6.0;
      ballRadius = 24.0;
      deviceMulti = 2;
    } else {
      ballLaunchSpeedXMenu = 4.4;
      ballLaunchSpeedYMenu = 26.0;
      ballLaunchSpeedXGame = 4.4;
      ballLaunchSpeedYGame = 2.0;
      ballRadius = 12.0;
      deviceMulti = 1;
    }
  }
  return self;
}

-(SKNode *)addRandomItem:(CGSize)size {
  if (objectArray.count <= 0) {
    [objectArray addObjectsFromArray:@[@"ball", @"ball", @"ball", @"ball", @"bowlingBall", @"pineapple", @"torch"]];
  }
  
  NSString *randItem = @"ball";
  uint32_t rnd = arc4random_uniform(randomItemsAdded + 4);
  if (!self.isMainMenu) {
    randItem = [objectArray objectAtIndex:rnd];
  }
  
  if ([randItem isEqualToString:@"ball"]) {
    item = [self ball];
    item.name = @"ball";
  } else if ([randItem isEqualToString:@"bowlingBall"]) {
    item = [self bowlingBall];
    item.name = @"bowlingBall";
  } else if ([randItem isEqualToString:@"pineapple"]) {
    item = [self pineapple];
    item.name = @"pineapple";
  } else if ([randItem isEqualToString:@"torch"]) {
    item = [self torch];
    item.name = @"torch";
  }
  
  NSArray* sides = @[[NSNumber numberWithDouble:size.width - size.width/1.05], [NSNumber numberWithDouble:size.width/1.01]];
  NSArray* sidesBeneath = @[[NSNumber numberWithDouble:size.width/6.4], [NSNumber numberWithDouble:size.width - size.width/6.4]];
  
  if (self.isMainMenu) {
    item.position = CGPointMake([[sidesBeneath objectAtIndex:arc4random() % [sidesBeneath count]] doubleValue], 20);
    item.zPosition = 95;
  } else {
    item.position = CGPointMake([[sides objectAtIndex:arc4random() % [sides count]] doubleValue], ((double)arc4random() / ARC4RANDOM_MAX) * ((size.height/1.01) - (size.height/1.6)) + (size.height/1.6));
    item.zPosition = 100;
  }
  
  if (!self.isMainMenu) {
    if (counter == 10) {
      if (randomItemsAdded <= 7) {
        randomItemsAdded++;
      }
    } else if (counter == 20) {
      if (randomItemsAdded <= 11) {
        randomItemsAdded++;
      }
    } else if (counter == 30) {
      if (randomItemsAdded <= 15) {
        randomItemsAdded++;
      }
    }
    counter++;
  }
  
  return item;
}

-(void)initPhysics {
  NSArray* weightTypes = @[[NSNumber numberWithFloat:0.3f], [NSNumber numberWithFloat:0.6f], [NSNumber numberWithFloat:0.8f]];
  
  if ([item.name isEqualToString:@"ball"]) {
    item.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ballRadius];
    float randType = [[weightTypes objectAtIndex:arc4random() % [weightTypes count]] floatValue];
    item.physicsBody.linearDamping = randType;
  }else if ([item.name isEqualToString:@"bowlingBall"]) {
    item.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bowlingBallRadius];
    item.physicsBody.linearDamping = 1.1f;
    [item.physicsBody applyAngularImpulse:0.01f];
  } else if ([item.name isEqualToString:@"pineapple"]) {
    UIBezierPath* polygonPath = [UIBezierPath bezierPath];
    [polygonPath moveToPoint: CGPointMake(-1, 18.5)];
    [polygonPath addLineToPoint: CGPointMake(6.35, 14.97)];
    [polygonPath addLineToPoint: CGPointMake(10.89, 5.72)];
    [polygonPath addLineToPoint: CGPointMake(10.89, -5.72)];
    [polygonPath addLineToPoint: CGPointMake(6.35, -14.97)];
    [polygonPath addLineToPoint: CGPointMake(-1, -18.5)];
    [polygonPath addLineToPoint: CGPointMake(-8.35, -14.97)];
    [polygonPath addLineToPoint: CGPointMake(-12.89, -5.72)];
    [polygonPath addLineToPoint: CGPointMake(-12.89, 5.72)];
    [polygonPath addLineToPoint: CGPointMake(-8.35, 14.97)];
    [polygonPath closePath];
    item.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[polygonPath CGPath]];
    item.physicsBody.linearDamping = 0.5f;
  } else if ([item.name isEqualToString:@"torch"]) {
    item.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(14, 56)];
    item.physicsBody.linearDamping = 0.4f;
    [item.physicsBody applyAngularImpulse:0.01f];
  }
  item.name = @"item";
  item.physicsBody.mass = 0.020106 / deviceMulti;
  item.physicsBody.density = 0.999990 / deviceMulti;
  item.physicsBody.restitution = 0.0f;
  item.physicsBody.categoryBitMask = itemCategory;
  item.physicsBody.contactTestBitMask = fingerCategory;
  item.physicsBody.collisionBitMask = fingerCategory;
  if (self.isMainMenu) {
    if (item.position.x <= 160) {
      [item.physicsBody applyImpulse:CGVectorMake(ballLaunchSpeedXMenu, ballLaunchSpeedYMenu)];
    } else {
      [item.physicsBody applyImpulse:CGVectorMake(-ballLaunchSpeedXMenu, ballLaunchSpeedYMenu)];
    }
    
  } else {
    if (item.position.x < 100) {
      [item.physicsBody applyImpulse:CGVectorMake(ballLaunchSpeedXGame, ballLaunchSpeedYGame)];
    } else {
      [item.physicsBody applyImpulse:CGVectorMake(-ballLaunchSpeedXGame, ballLaunchSpeedYGame)];
    }
  }
}

-(SKNode*)ball {
  UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-ballRadius, -ballRadius, ballRadius * 2, ballRadius * 2)];
  SKColor* orangeColor = [SKColor colorWithRed: 1 green: 0.631 blue: 0 alpha: 1];
  SKColor* redColor = [SKColor colorWithRed: 1 green: 0.176 blue: 0.333 alpha: 1];
  SKColor* blueColor = [SKColor colorWithRed: 0.259 green: 0.804 blue: 0 alpha: 1];
  SKColor* purpleColor = [SKColor colorWithRed: 0.659 green: 0.337 blue: 0.898 alpha: 1];
  SKColor* crimsonColor = [SKColor colorWithRed: 0.719 green: 0.156 blue: 0.33 alpha: 1];
  SKColor* goldColor = [SKColor colorWithRed: 0.918 green: 0.863 blue: 0.059 alpha: 1];
  
  NSArray* colorArray = @[orangeColor, redColor, blueColor, purpleColor, crimsonColor, goldColor];
  SKShapeNode* ball = [[SKShapeNode alloc] init];
  ball.path = [circlePath CGPath];
  ball.fillColor = [colorArray objectAtIndex:arc4random() % [colorArray count]];
  ball.name = @"ball";
  [ball setLineWidth:0.0f];
  return ball;
}

-(SKNode*)bowlingBall {
  SKSpriteNode* bowlingBall = [[SKSpriteNode alloc]initWithImageNamed:@"BowlingBall"];
  bowlingBallRadius = 18.0f;
  bowlingBall.name = @"bowlingBall";
  return bowlingBall;
}

-(SKNode*)pineapple {
  SKSpriteNode* pineapple = [[SKSpriteNode alloc] initWithImageNamed:@"Pineapple"];
  pineapple.name = @"pineapple";
  return pineapple;
}

-(SKNode*)torch {
  SKSpriteNode* torch = [[SKSpriteNode alloc] initWithImageNamed:@"Torch"];
  torch.name = @"torch";
  return torch;
}

@end
