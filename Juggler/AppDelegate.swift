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
    Chartboost.setShouldRequestInterstitialsInFirstSession(false)
    
    return true
  }

  func applicationDidBecomeActive(application: UIApplication) {
    Chartboost.startWithAppId("538794871873da029599b73f", appSignature: "673ce4e7a34816fe6867a232ec58c1f7452900cb", delegate: nil)

  }

}

