//
//  GameCenterControl.h
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

@interface GameCenterControl : NSObject {
  BOOL isGameCenterAvailable;
  BOOL userAuthenticated;
}

@property (assign, readonly) BOOL isGameCenterAvailable;

+ (GameCenterControl *)sharedInstance;

- (void)authenticateLocalUser;
- (void)showLeaderboard;

@end
