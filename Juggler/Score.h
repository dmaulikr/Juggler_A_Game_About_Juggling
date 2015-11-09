//
//  Score.h
//  Juggler
//
//  Created by Evan Lewis on 5/29/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject

- (void)add:(int)points;
- (void)saveScore;
- (int)getScore;
- (int)getHighScore;
- (void)clearScore;

@end
