//
//  AppDelegate.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioSession.h"
#import "GameCenterControl.h"
#import "JugglerViewController.h"

@interface AppDelegate () {
    SKView *skView;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GameCenterControl sharedInstance] authenticateLocalUser];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidEnterBackground" object:nil];
    // pause sprite kit
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = YES;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{

    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    // Must be called every time your app becomes active.
    [Chartboost startWithAppId:@"538794871873da029599b73f" appSignature:@"673ce4e7a34816fe6867a232ec58c1f7452900cb" delegate:self];
    
    // pause sprite kit
    SKView *view = (SKView *)self.window.rootViewController.view;
    view.paused = NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidBecomeActive" object:nil];

        // Show an ad at location "CBLocationHomeScreen"
        [[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
        NSLog(@"showing interstitial");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Chartboost

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}

@end
