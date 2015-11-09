//
//  GameCenterControl.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "GameCenterControl.h"

@interface GameCenterControl () <GKGameCenterControllerDelegate> {
    
    BOOL _gameCenterFeaturesEnabled;
    
}
@end


@implementation GameCenterControl

@synthesize isGameCenterAvailable;

static GameCenterControl* sharedControl = nil;
+ (GameCenterControl*) sharedInstance {
    if (!sharedControl) {
        sharedControl = [[GameCenterControl alloc]init];
    }
    return sharedControl;
}

-(BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        isGameCenterAvailable = [self isGameCenterAvailable];
        if (isGameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication Changed. User Authenticated");
        userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        
        NSLog(@"Authentication Changed. User Not Authenticated");
        userAuthenticated = FALSE;
    }
    
}


-(void) authenticateLocalUser {
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController *gcvc,NSError *error) {
            if(gcvc) {
                [self presentViewController:gcvc];
            }
            else {
                _gameCenterFeaturesEnabled = NO;
            }
        };
    }
        else if ([GKLocalPlayer localPlayer].authenticated == YES){
        _gameCenterFeaturesEnabled = YES;
    }
}

-(UIViewController*) getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)gcvc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:gcvc animated:YES completion:nil];
}

-(void)showLeaderboard {
    GKGameCenterViewController*leaderboardController = [[GKGameCenterViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.leaderboardIdentifier = @"Juggler_Leaderboard";
        leaderboardController.viewState = GKGameCenterViewControllerStateLeaderboards;
        leaderboardController.gameCenterDelegate = self;
        [self presentViewController:leaderboardController];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController {
    UIViewController *vc = gameCenterViewController.view.window.rootViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end