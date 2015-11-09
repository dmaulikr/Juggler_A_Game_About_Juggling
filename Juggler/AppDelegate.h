//
//  AppDelegate.h
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chartboost.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ChartboostDelegate> {
}

@property (strong, nonatomic) UIWindow *window;

@end
