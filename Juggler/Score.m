//
//  Score.m
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import "Score.h"

@interface Score() {
    
}

@property (nonatomic, assign) int score;

@end

@implementation Score

- (void)add:(int)points {
    self.score += points;
}

- (void)saveScore {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.score forKey:@"Juggler_HighScore"];
    [userDefaults synchronize];
    
    [self reportHighScore:self.score];
}

- (void)reportHighScore:(NSInteger)highScore {
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Juggler_Leaderboard"];
        score.value = highScore;
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

-(int)getHighScore {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    return (int)[userDefaults integerForKey:@"Juggler_HighScore"];
}

-(int)getScore {
    return self.score;
}

-(void)clearScore {
    self.score = 0;
}

@end
