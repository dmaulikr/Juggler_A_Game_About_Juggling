//
//  MainMenuScene.swift
//  Juggler
//
//  Created by Evan Lewis on 6/9/16.
//  Copyright © 2016 Evan Lewis. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
  
  private var contentCreated = false
  
  override func didMoveToView(view: SKView) {
    if !self.contentCreated {
      self.contentCreated = true
      self.createSceneContents()
    }
  }
  
  private func createSceneContents() {
    
  }
  
}
