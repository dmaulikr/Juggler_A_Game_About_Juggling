//
//  AppDelegate.swift
//  Juggler
//
//  Created by Evan Lewis on 6/9/16.
//  Copyright © 2016 Evan Lewis. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GameAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Fabric.with([Crashlytics.self, GameAnalytics.self])
    
    // Enable log to output simple details (disable in production)
    GameAnalytics.setEnabledInfoLog(true)
    // Enable log to output full event JSON (disable in production)
    GameAnalytics.setEnabledVerboseLog(true)
    
    // Example: configure available virtual currencies and item types for later use in resource events
    // GameAnalytics.configureAv$ailableResourceCurrencies(["gems", "gold"])
    // GameAnalytics.configureAvailableResourceItemTypes(["boost", "lives"])
    
    // Example: configure available custom dimensions for later use when specifying these
    // GameAnalytics.configureAvailableCustomDimensions01(["ninja", "samurai"])
    // GameAnalytics.configureAvailableCustomDimensions02(["whale", "dolphin"])
    // GameAnalytics.configureAvailableCustomDimensions03(["horde", "alliance"])
    
    // Configure build version
    GameAnalytics.configureBuild("1.0.0")
    
    // initialize GameAnalytics - this method will use app keys injected by Fabric
    GameAnalytics.initializeWithConfiguredGameKeyAndGameSecret()
    // to manually specify keys use this method:
    //GameAnalytics.initializeWithGameKey("[game_key]", gameSecret:"[game_secret]")
    
    // Initialize the Chartboost library
    Chartboost.startWithAppId("538794871873da029599b73f", appSignature: "673ce4e7a34816fe6867a232ec58c1f7452900cb", delegate: nil)
    Chartboost.setShouldRequestInterstitialsInFirstSession(false)
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

