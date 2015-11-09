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
@property (strong, nonatomic) IBOutlet ADBannerView *bottomAdView;

@end

@implementation JugglerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View will appear");
    MainMenuScene* mainMenu = [[MainMenuScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    gameScene = [[GameScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        CGPoint origin = CGPointMake(0.0,
                                     self.view.frame.size.height -
                                     CGSizeFromGADAdSize(
                                                         kGADAdSizeSmartBannerPortrait).height);
        
        bannerView = [[GADBannerView alloc]
                          initWithAdSize:kGADAdSizeSmartBannerPortrait
                          origin:origin];
    } else {
        bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    }
    // Specify the ad unit ID.
    bannerView.adUnitID = @"ca-app-pub-7015186548877695/9848608561";
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    self.bottomAdView.delegate = self;
    self.bottomAdView.hidden = YES;
    
    /*self.spriteView.showsDrawCount = YES;
    self.spriteView.showsNodeCount = YES;
    self.spriteView.showsFPS = YES;
    self.spriteView.showsPhysics = YES;*/
    [self.spriteView presentScene: mainMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showGameCenterLeaderboard {
    [[GameCenterControl sharedInstance]showLeaderboard];
}

#pragma mark - iAdBanner Delegates

-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error in Loading Banner!");

    [self.view addSubview:bannerView];
    // Initiate a generic request to load it with an ad.
    [bannerView loadRequest:[GADRequest request]];
    bannerView.hidden = NO;
    self.bottomAdView.hidden = YES;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd banner Loaded Successfully!");
    self.bottomAdView.hidden = NO;
    if (bannerView) {
        bannerView.hidden = YES;
    }
}

-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd Banner will load!");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    SKView *skView = (SKView *)self.view;
    skView.scene.paused = YES;
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    SKView *skView = (SKView *)self.view;
    skView.scene.paused = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
