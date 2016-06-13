//
//  AppDelegate.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioSession.h"
#import <Fabric/Fabric.h>
#import <GameAnalytics/GameAnalytics.h>
#import <Crashlytics/Crashlytics.h>
#import <Chartboost/Chartboost.h>
#import "GameCenterControl.h"
#import "JugglerViewController.h"

@interface AppDelegate () <ChartboostDelegate> {
    SKView *skView;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class], [GameAnalytics class]]];
    [[GameCenterControl sharedInstance] authenticateLocalUser];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidEnterBackground" object:nil];
    // pause sprite kit
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    // Must be called every time your app becomes active.
    [Chartboost startWithAppId:@"538794871873da029599b73f" appSignature:@"673ce4e7a34816fe6867a232ec58c1f7452900cb" delegate:self];
    
    // Pause sprite kit
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidBecomeActive" object:nil];
    
    // Show an ad at location "CBLocationHomeScreen"
    [Chartboost showInterstitial:CBLocationHomeScreen];
    DLog(@"showing interstitial");
}

#pragma mark Chartboost

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}

@end
