//
//  AudioSession.h
//  Juggler
//
//  Created by Evan Lewis on 6/9/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//
#import "AppDelegate.h"

@interface AudioSession : NSObject  {
    AudioSession* audioSession;
    AVAudioPlayer* audioPlayer;
}

@property (nonatomic, assign) BOOL isAudioSessionActive; // Informs if SpriteKit should play sounds(SpriteKit BUG)
@property (nonatomic, retain) AVAudioPlayer* audioPlayer;
@property BOOL isOtherAudioPlaying; // Informs if other app makes sounds

- (void)startAudio;
- (void)stopAudio;
- (void)pauseAudio;
- (void)resumeAudio;
- (SKAction*)playSound:(NSString*)sound;
- (void)loadAudioSettings;
- (BOOL)toggleAudioSettings;

@end
