//
//  GameScene.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "Item.h"
#import "Score.h"

static const uint32_t itemCategory = 0x1 << 0;
static const uint32_t fingerCategory = 0x1 << 1;
static const int zIndex = 100;

@interface GameScene () {
  Item* item;
  Score* score;
  AudioSession* audioSession;
  SKShapeNode* fingerLocation;
  SKSpriteNode* pauseButton;
  SKShapeNode* pauseLabel;
  SKSpriteNode* cityBackground;
  SKShapeNode *blur;
  SKLabelNode* scoreLabel;
  NSTimer* cloudTimer;
  NSTimer* itemLaunchTimer;
  int cloudCounter;
  
#pragma mark iPad
  int deviceMulti;
  CGPoint fingerPosition;
  CGRect tutorialRect;
  float yGravity;
  CGPoint scorePosition;
}

@property BOOL contentCreated;
@property BOOL isTutorialShowing;
@property BOOL isGameOver;
@property int itemCount;
@property (nonatomic) SKEffectNode* blurLayer;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
  DLog(@"did move to view");
  if (!self.contentCreated) {
    [self createSceneContents];
    self.contentCreated = YES;
  }
}

- (void)createSceneContents {
  
  audioSession = [[AudioSession alloc] init];
  
  if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    deviceMulti = 2;
    yGravity = -8.0f;
    fingerPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2.8);
    tutorialRect = CGRectMake(0, self.frame.size.height/7, self.frame.size.width, 380 * deviceMulti);
    scorePosition = CGPointMake(self.size.width/2, self.size.height/1.7);
  } else {
    deviceMulti = 1;
    yGravity = -4.0f;
    fingerPosition = CGPointMake(self.frame.size.width/1.8, self.frame.size.height/3.1);
    tutorialRect = CGRectMake(0, self.frame.size.height/7, self.frame.size.width, 380 * deviceMulti);
    scorePosition = CGPointMake(self.size.width/2, self.size.height/1.7);
  }
  
  self.backgroundColor = [SKColor colorWithRed: 0.388 green: 0.851 blue: 0.855 alpha: 1];
  self.physicsWorld.contactDelegate = self;
  self.physicsWorld.gravity = CGVectorMake(0.0f, yGravity);
  cityBackground = [[SKSpriteNode alloc] initWithImageNamed:@"City"];
  cityBackground.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2.87);
  cityBackground.zPosition = zIndex - 5;
  cityBackground.alpha = 0;
  [self addChild:cityBackground];
  [cityBackground runAction:[SKAction fadeInWithDuration:1.0f]];
  
  // Left Wall
  SKNode *node = [SKNode node];
  node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0f, 0.0f, 1.0f, CGRectGetHeight(self.frame)*6)];
  [self addChild:node];
  
  // Right wall
  node = [SKNode node];
  node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetWidth(self.frame) - 1.0f, 0.0f, 1.0f, CGRectGetHeight(self.frame)*6)];
  [self addChild:node];
  
  item = [[Item alloc] init];
  score = [[Score alloc] init];
  self.itemCount = 0;
  cloudCounter = 0;
  [item setIsMainMenu:NO];
  
  //Score Label
  scoreLabel = [self newScoreLabel];
  scoreLabel.alpha = 0;
  [self addChild:scoreLabel];
  [score clearScore];
  [self addCloud];
  cloudTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                target:self
                                              selector:@selector(updateWithTimer:)
                                              userInfo:nil
                                               repeats:YES];
  [[NSNotificationCenter defaultCenter] addObserver: self
                                           selector: @selector(becameActive)
                                               name: @"applicationDidBecomeActive"
                                             object: nil];
  
  BOOL notFirstRun = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstRun"];
  if(notFirstRun){
    [self showTutorial];
    self.isTutorialShowing = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else {
    [self startGameCountdown];
  }
}

- (void)startGameCountdown {
  UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-36 * deviceMulti, -36 * deviceMulti, 72 * deviceMulti, 72 * deviceMulti)];
  SKShapeNode* ball = [[SKShapeNode alloc] init];
  ball.path = [circlePath CGPath];
  ball.fillColor = [SKColor redColor];
  ball.zPosition = zIndex + 10;
  ball.alpha = 0;
  ball.name = @"ball";
  ball.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.4);
  [ball setLineWidth:0.0f];
  [self addChild:ball];
  
  SKShapeNode* ball2 = [[SKShapeNode alloc] init];
  ball2.path = [circlePath CGPath];
  ball2.fillColor = [SKColor orangeColor];
  ball2.zPosition = zIndex + 5;
  ball2.alpha = 0;
  ball2.name = @"ball";
  ball2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.4);
  [ball2 setLineWidth:0.0f];
  [self addChild:ball2];
  
  SKShapeNode* ball3 = [[SKShapeNode alloc] init];
  ball3.path = [circlePath CGPath];
  ball3.fillColor = [SKColor greenColor];
  ball3.zPosition = zIndex;
  ball3.alpha = 0;
  ball3.name = @"ball";
  ball3.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.4);
  [ball3 setLineWidth:0.0f];
  [self addChild:ball3];
  
  SKAction* fadeIn = [SKAction fadeInWithDuration:0.4];
  [ball runAction:fadeIn];
  [ball2 runAction:fadeIn];
  [ball3 runAction:fadeIn];
  SKAction* wait = [SKAction waitForDuration:0.4];
  SKAction* moveY = [SKAction moveByX:0 y:-120 * deviceMulti duration:0.1];
  moveY.timingMode = SKActionTimingEaseOut;
  [ball2 runAction:[SKAction sequence:@[wait, moveY]]];
  [scoreLabel runAction:[SKAction sequence:@[wait,[SKAction fadeInWithDuration:1.0]]]];
  [ball3 runAction:[SKAction sequence:@[wait, moveY, wait, moveY, wait]] completion:^{
    [ball runAction:[SKAction fadeOutWithDuration:0.5] completion:^{
      [ball removeFromParent];
    }];
    [ball2 runAction:[SKAction fadeOutWithDuration:0.5] completion:^{
      [ball2 removeFromParent];
    }];
    [ball3 runAction:[SKAction fadeOutWithDuration:0.5] completion:^{
      [ball3 removeFromParent];
      [self startGame];
      [self runAction:[audioSession playSound:@"Click.mp3"]];
      [self addChild:[self newPauseButton]];
      self.inGame = YES;
    }];
  }];
}

-(void)startGame {
  [self addChild:[self newPauseButton]];
  [self launchItem];
  itemLaunchTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                     target:self
                                                   selector:@selector(updateGameWithTimer:)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)endGame {
  DLog(@"Game Over");
  [self updateScore];
  self.isGameOver = YES;
  if ([score getScore] > [score getHighScore]) {
    [score saveScore];
  }
  [self runAction:[audioSession playSound:@"Buzz.mp3"]];
  self.inGame = NO;
  [self.physicsWorld setGravity:CGVectorMake(0.0f, 1.0f)];
  [itemLaunchTimer invalidate]; itemLaunchTimer = nil;
  [cloudTimer invalidate]; cloudTimer = nil;
  [self shakeNode:cityBackground];
  GameOverScene *gameOverScene  = [[GameOverScene alloc] initWithSize:self.size];
  if ([score getScore] != 0) {
    [gameOverScene sendScore:[score getScore]];
  }
  [scoreLabel runAction:[SKAction fadeOutWithDuration:0.4f]];
  [self enumerateChildNodesWithName:@"item" usingBlock:^(SKNode *node, BOOL *stop) {
    [node.physicsBody setCollisionBitMask:0x0];
    [node runAction:[SKAction fadeOutWithDuration:1.0f]];
  }];
  [self.view.scene runAction:[SKAction waitForDuration:1.0f] completion:^{
    [item setIsMainMenu:YES];
    [self.view presentScene:gameOverScene transition:[SKTransition pushWithDirection:SKTransitionDirectionDown duration:0.6]];
  }];
}

- (void)launchItem {
  [self addChild:[item addRandomItem:self.size]];
  [item initPhysics];
  self.itemCount++;
}

- (void)pauseGame {
  if (!self.view.paused) {
    [self runAction:[SKAction runBlock:^{
      [self addChild:[self newPauseLabel]];
    }] completion:^{
      self.view.paused = YES;
    }];
  } else {
    self.view.paused = NO;
    [pauseLabel removeFromParent];
  }
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInNode:self];
    SKNode* nodeAtLocation = [self nodeAtPoint:location];
    if ([nodeAtLocation.name isEqualToString:@"pauseButton"]) {
      [self pauseGame];
    }
    if (location.y > (self.frame.origin.y + 48)) {
      fingerLocation = [[SKShapeNode alloc] init];
      UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-24 * deviceMulti, -24 * deviceMulti, 48 * deviceMulti, 48 * deviceMulti)];
      fingerLocation.path = [circlePath CGPath];
      fingerLocation.strokeColor = [SKColor grayColor];
      fingerLocation.lineWidth = 2.0;
      fingerLocation.position = location;
      fingerLocation.name = @"fingerLocation";
      [self addChild:fingerLocation];
      fingerLocation.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:fingerLocation.frame.size.width/2];
      fingerLocation.physicsBody.friction = 0.0f;
      fingerLocation.physicsBody.restitution = 2.0f;
      fingerLocation.physicsBody.linearDamping = 0.0f;
      fingerLocation.physicsBody.dynamic = NO;
      fingerLocation.physicsBody.allowsRotation = NO;
      fingerLocation.physicsBody.categoryBitMask = fingerCategory;
      fingerLocation.physicsBody.contactTestBitMask = 0x0;
      fingerLocation.physicsBody.collisionBitMask = itemCategory;
      fingerLocation.zPosition = zIndex;
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch* touch in touches) {
    fingerLocation.position = [touch locationInNode:self];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self enumerateChildNodesWithName:@"fingerLocation" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  
  if (self.isTutorialShowing) {
    self.isTutorialShowing = NO;
    [self enumerateChildNodesWithName:@"Tutorial Object" usingBlock:^(SKNode *node, BOOL *stop) {
      [node runAction:[SKAction fadeOutWithDuration:0.3] completion:^{
        [node removeFromParent];
      }];
    }];
    [self startGameCountdown];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
  if (!contact.bodyA.node.parent || !contact.bodyB.node.parent) return;
  
  if ([contact.bodyA.node.name isEqualToString:@"item"] && [contact.bodyB.node.name isEqualToString:@"fingerLocation"]) {
    [contact.bodyA.node.physicsBody setLinearDamping:contact.bodyA.node.physicsBody.linearDamping - 0.02];
    [score add:3];
    [self updateScore];
  }
  
  if ([contact.bodyB.node.name isEqualToString:@"item"] && [contact.bodyA.node.name isEqualToString:@"fingerLocation"]) {
    [contact.bodyB.node.physicsBody setLinearDamping:contact.bodyB.node.physicsBody.linearDamping - 0.02];
    [score add:3];
    [self updateScore];
  }
}

- (void)updateWithTimer:(NSTimer*)timer {
  if (cloudCounter <= 3) {
    [self addCloud];
  }
}

- (void)updateGameWithTimer:(NSTimer*)timer {
  if (self.itemCount <= 2 && !self.isGameOver) {
    [self launchItem];
  }
}

- (void)didSimulatePhysics {
  [self enumerateChildNodesWithName:@"item" usingBlock:^(SKNode *node, BOOL *stop) {
    if (node.position.y < 0) {
      [node removeFromParent];
      self.itemCount--;
      [self endGame];
    }
    if ((node.position.y >= self.size.height + self.size.height/12) && !self.isGameOver) {
      [node setName:@"toRemove"];
      [scoreLabel runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0.5f duration:0.5f], [SKAction fadeAlphaTo:1.0f duration:0.5f]]]];
      if (node.physicsBody.linearDamping > 0.8) {
        [score add:1];
      }
      [score add:10];
      [self updateScore];
      [self runAction:[audioSession playSound:@"Score.mp3"]];
      [node.physicsBody setCollisionBitMask:0x0];
      [node setZPosition:zIndex - 25];
      [node runAction:[SKAction scaleTo:0.0f duration:2] completion:^{
        [node removeFromParent];
        [self launchItem];
        self.itemCount--;
      }];
    }
  }];
}

- (void)showTutorial {
  SKShapeNode* tutorialBackground = [[SKShapeNode alloc] init];
  UIBezierPath* backgroundPath = [UIBezierPath bezierPathWithRect:tutorialRect];
  tutorialBackground.path = [backgroundPath CGPath];
  tutorialBackground.zPosition = zIndex + 5;
  tutorialBackground.fillColor = [SKColor whiteColor];
  tutorialBackground.alpha = 0;
  tutorialBackground.name = @"Tutorial Object";
  [self addChild:tutorialBackground];
  
  SKLabelNode *instructionsString1 = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica Neue"];
  instructionsString1.text = @"Tap and hold one finger on the screen";
  instructionsString1.fontSize = 14 * deviceMulti;
  instructionsString1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.4);
  instructionsString1.zPosition = zIndex + 6;
  [instructionsString1 setFontColor:[SKColor colorWithRed: 0.52 green: 0.52 blue: 0.52 alpha: 1]];
  instructionsString1.name = @"Tutorial Object";
  [self addChild:instructionsString1];
  
  SKLabelNode *instructionsString2 = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica Neue"];
  instructionsString2.text = @"Use your finger to launch the balls into the air";
  instructionsString2.fontSize = 14 * deviceMulti;
  instructionsString2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.5);
  instructionsString2.zPosition = zIndex + 6;
  [instructionsString2 setFontColor:[SKColor colorWithRed: 0.52 green: 0.52 blue: 0.52 alpha: 1]];
  instructionsString2.name = @"Tutorial Object";
  [self addChild:instructionsString2];
  
  [tutorialBackground runAction:[SKAction fadeInWithDuration:0.2]];
  
  SKNode* ball = [item ball];
  ball.name = @"Tutorial Object";
  ball.position = CGPointMake(270, 346.5);
  ball.alpha = 0;
  ball.zPosition = zIndex + 10;
  [self addChild:ball];
  
  // Ball Drawing
  UIBezierPath* ballPath = [UIBezierPath bezierPath];
  [ballPath moveToPoint: CGPointMake(270 * deviceMulti, 346.5 * deviceMulti)];
  [ballPath addCurveToPoint: CGPointMake(161.5 * deviceMulti, 274.5 * deviceMulti) controlPoint1: CGPointMake(213.49 * deviceMulti, 359.37 * deviceMulti) controlPoint2: CGPointMake(168.01 * deviceMulti, 265 * deviceMulti)];
  [ballPath addCurveToPoint: CGPointMake(277.5 * deviceMulti, 468.5 * deviceMulti) controlPoint1: CGPointMake(168.01 * deviceMulti, 265 * deviceMulti) controlPoint2: CGPointMake(169.93 * deviceMulti, 475.17 * deviceMulti)];
  
  SKSpriteNode* finger = [[SKSpriteNode alloc] initWithImageNamed:@"Finger"];
  finger.position = fingerPosition;
  finger.zPosition = zIndex + 10;
  finger.name = @"Tutorial Object";
  [finger setAlpha:0];
  [self addChild:finger];
  
  [finger runAction:[SKAction fadeInWithDuration:0.6f]];
  SKAction *pathAction = [SKAction followPath:ballPath.CGPath asOffset:NO orientToPath:YES duration:2.3f];
  pathAction.timingMode = SKActionTimingEaseInEaseOut;
  [ball runAction:pathAction completion:^{
    [ball removeFromParent];
    [finger runAction:[SKAction fadeOutWithDuration:1.3f] completion:^{
      [finger removeFromParent];
      if (self.isTutorialShowing) {
        [self showTutorial];
      }
    }];
  }];
  [ball runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:0.3],[SKAction waitForDuration:1.5], [SKAction fadeOutWithDuration:0.3]]]];
}

- (void)addCloud {
  cloudCounter++;
  NSArray* cloudArray = @[@"Cloud1", @"Cloud2", @"Cloud3"];
  SKSpriteNode* cloud = [[SKSpriteNode alloc] initWithImageNamed:[cloudArray objectAtIndex:arc4random() % [cloudArray count]]];
  cloud.position = CGPointMake((0 - cloud.frame.size.width), ((double)arc4random() / ARC4RANDOM_MAX) * ((self.size.height) - (self.size.height/1.5)) + (self.size.height/1.5));
  cloud.name = @"Cloud";
  cloud.zPosition = zIndex - 30;
  [self addChild:cloud];
  [cloud runAction:[SKAction moveToX:self.size.width + cloud.size.width duration:((double)arc4random() / ARC4RANDOM_MAX) * ((40.0f) - (15.0f)) + (15.0f)] completion:^{
    [cloud removeFromParent];
    cloudCounter--;
  }];
}

- (void)updateScore {
  if ([score getScore] % 100000 != [score getScore]) {
    scoreLabel.fontSize = 80 * deviceMulti;
  } else if ([score getScore] % 10000 != [score getScore]) {
    scoreLabel.fontSize = 120 * deviceMulti;
  } else if ([score getScore] % 1000 != [score getScore]) {
    scoreLabel.fontSize = 160 * deviceMulti;
  }else {
    scoreLabel.fontSize = 200 * deviceMulti;
  }
  scoreLabel.text = [NSString stringWithFormat:@"%i", [score getScore]];
}

- (SKLabelNode*)newScoreLabel {
  SKLabelNode* label = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica Neue"];
  label.text = @"0";
  label.fontSize = 200 * deviceMulti;
  label.position = scorePosition;
  label.zPosition = zIndex - 10;
  [label setFontColor:[SKColor colorWithRed: 0.52 green: 0.52 blue: 0.52 alpha: 1]];
  
  return label;
}

- (SKSpriteNode*)newPauseButton {
  
  pauseButton = [[SKSpriteNode alloc]initWithImageNamed:@"Pause-Button"];
  pauseButton.name = @"pauseButton";
  pauseButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.05);
  pauseButton.zPosition = zIndex + 10;
  pauseButton.xScale = 1.5;
  pauseButton.yScale = 1.5;
  
  return pauseButton;
}

- (SKShapeNode*)newPauseLabel {
  
  UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-48 * deviceMulti, -48 * deviceMulti, 96 * deviceMulti, 96 * deviceMulti)];
  pauseLabel = [[SKShapeNode alloc] init];
  pauseLabel.path = [circlePath CGPath];
  pauseLabel.fillColor = [SKColor redColor];
  pauseLabel.zPosition = zIndex + 10;
  pauseLabel.alpha = 1;
  pauseLabel.name = @"pauseButton";
  pauseLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
  [pauseLabel setLineWidth:0.0f];
  
  return pauseLabel;
}

- (void) shakeNode:(SKNode*)node {
  // Reset the camera's position
  //node.position = CGPointZero;
  
  // Cancel any existing shake actions
  [node removeActionForKey:@"shake"];
  
  // The number of individual movements that the shake will be made up of
  int shakeSteps = 15;
  
  // How "big" the shake is
  float shakeDistance = 20;
  
  // How long the shake should go on for
  float shakeDuration = 0.25;
  
  // An array to store the individual movements in
  NSMutableArray* shakeActions = [NSMutableArray array];
  
  // Start at shakeSteps, and step down to 0
  for (int i = shakeSteps; i > 0; i--) {
    
    // How long this specific shake movement will take
    float shakeMovementDuration = shakeDuration / shakeSteps;
    
    // This will be 1.0 at the start and gradually move down to 0.0
    float shakeAmount= i / (float)shakeSteps;
    
    // Take the current position - we'll then add an offset from that
    CGPoint shakePosition = node.position;
    
    // Pick a random amount from -shakeDistance to shakeDistance
    shakePosition.x += (arc4random_uniform(shakeDistance*2) - shakeDistance)
    * shakeAmount;
    shakePosition.y += (arc4random_uniform(shakeDistance*2) - shakeDistance)
    * shakeAmount;
    
    // Create the action that moves the node to the new location, and
    // add it to the list
    SKAction* shakeMovementAction = [SKAction moveTo:shakePosition
                                            duration:shakeMovementDuration];
    [shakeActions addObject:shakeMovementAction];
  }
  // Run the shake
  SKAction* shakeSequence = [SKAction sequence:shakeActions];
  [node runAction:shakeSequence withKey:@"shake"];
}

- (void)becameActive {
  [self pauseGame];
}

@end
