//
//  AudioSession.m
//  Juggler
//
//  Created by Evan Lewis on 6/9/14.
//  Copyright (c) 2014 Evan Lewis. All rights reserved.
//

@import MediaPlayer;
#import "AudioSession.h"

@implementation AudioSession {
}

@synthesize audioPlayer;

- (instancetype)init {
  if (self = [super init]) {
    NSURL* soundFileURL = [[NSBundle mainBundle] URLForResource:@"The_Juggler" withExtension:@"mp3"];
    NSError* error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundFileURL error:&error];
    self.audioPlayer.numberOfLoops = -1;
    if (error != nil) {
      DLog(@"Failed to load the sound: %@", [error localizedDescription]);
    }
    [self loadAudioSettings];
  }
  return self;
}

- (void)startAudio {
  if (self.isAudioSessionActive) {
    //[self.audioPlayer prepareToPlay];
    //[self.audioPlayer play];
  }
}

- (void)stopAudio {
  //[self.audioPlayer stop];
  self.isAudioSessionActive = NO;
}

- (void)pauseAudio {
  //[self.audioPlayer pause];
  self.isAudioSessionActive = NO;
}

- (void)resumeAudio {
  if (self.isAudioSessionActive) {
    //[self.audioPlayer play];
  }
  self.isAudioSessionActive = YES;
}

- (SKAction *)playSound:(NSString *)sound {
  if(self.isAudioSessionActive) {
    //SKAction* playSound = [SKAction playSoundFileNamed:sound waitForCompletion:NO];
    //return playSound;
  }
  return nil;
}

- (void)loadAudioSettings {
  
  BOOL isRunMoreThanOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"];
  if(!isRunMoreThanOnce){
    DLog(@"First Run");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRunMoreThanOnce"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Juggler_isAudioSessionActive"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  BOOL defaults = [[NSUserDefaults standardUserDefaults] boolForKey:@"Juggler_isAudioSessionActive"];
  if ((defaults == YES) && ([[MPMusicPlayerController iPodMusicPlayer] playbackState] != MPMusicPlaybackStatePlaying)) {
    self.isAudioSessionActive = YES;
  } else {
    self.isAudioSessionActive = NO;
  }
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)toggleAudioSettings {
  if (self.isAudioSessionActive) {
    DLog(@"turning off audio");
    //[self stopAudio];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Juggler_isAudioSessionActive"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return NO;
  } else if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] != MPMusicPlaybackStatePlaying) {
    self.isAudioSessionActive = YES;
    //[self startAudio];
    DLog(@"turning on audio");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Juggler_isAudioSessionActive"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
  }
  return NO;
}


@end
