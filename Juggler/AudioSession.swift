//
//  AudioSession.swift
//  Juggler
//
//  Created by Evan Lewis on 6/9/16.
//  Copyright © 2016 Evan Lewis. All rights reserved.
//

import Foundation
import MediaPlayer
import SpriteKit

class AudioSession {
  
  var audioPlayer: AVAudioPlayer
  var audioSessionIsActive: Bool // Informs if SpriteKit should play sounds(SpriteKit BUG)
  
  init() {
    audioPlayer = AVAudioPlayer()
    
    if let soundFileURL = NSBundle.mainBundle().URLForResource("The_Juggler", withExtension: "mp3") {
      do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL)
      } catch {
        print(error)
      }
    }
    
    if !NSUserDefaults.standardUserDefaults().boolForKey("isRunMoreThanOnce") {
      print("First Run")
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isRunMoreThanOnce")
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Juggler_isAudioSessionActive")
    }
    
    if NSUserDefaults.standardUserDefaults().boolForKey("Juggler_isAudioSessionActive") && MPMusicPlayerController.systemMusicPlayer().playbackState != MPMusicPlaybackState.Playing {
      audioSessionIsActive = true
    } else {
      audioSessionIsActive = false
    }
    
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func startAudio() {
    if audioSessionIsActive {
      audioPlayer.prepareToPlay()
      audioPlayer.play()
    }
  }
  
  func stopAudio() {
    audioSessionIsActive = false
  }
  
  func playSound(sound: String) -> SKAction? {
    if self.audioSessionIsActive {
        return SKAction.playSoundFileNamed(sound, waitForCompletion: false)
    }
    return nil
  }
  
  func toggleAudioSettings() -> Bool {
    if (self.audioSessionIsActive) {
      self.stopAudio()
      NSUserDefaults.standardUserDefaults().setBool(false, forKey: "Juggler_isAudioSessionActive")
      NSUserDefaults.standardUserDefaults().synchronize()
      return false;
    } else if MPMusicPlayerController.systemMusicPlayer().playbackState != MPMusicPlaybackState.Playing {
      self.audioSessionIsActive = true;
      self.startAudio()
      
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Juggler_isAudioSessionActive")
      NSUserDefaults.standardUserDefaults().synchronize()
      return true;
    }
    return false;
  }
  
}