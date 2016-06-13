//
//  JugglerViewController.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "JugglerViewController.h"
#import "MainMenuScene.h"
#import "GameCenterControl.h"
#import "GameScene.h"
#import "AudioSession.h"

@interface JugglerViewController () {
  GameScene* gameScene;
}

@property (strong, nonatomic) IBOutlet SKView *spriteView;

@end

@implementation JugglerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  DLog(@"View will appear");
  MainMenuScene* mainMenu = [[MainMenuScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
  gameScene = [[GameScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
  
  /*self.spriteView.showsDrawCount = YES;
   self.spriteView.showsNodeCount = YES;
   self.spriteView.showsFPS = YES;
   self.spriteView.showsPhysics = YES;*/
  [self.spriteView presentScene: mainMenu];
}

-(void)showGameCenterLeaderboard {
  [[GameCenterControl sharedInstance]showLeaderboard];
}

@end
