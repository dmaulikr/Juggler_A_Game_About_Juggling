//
//  MainMenuScene.swift
//  Juggler
//
//  Created by Evan Lewis on 6/9/16.
//  Copyright © 2016 Evan Lewis. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
  
  private let soundNode = SKSpriteNode(imageNamed: "sound_button")
  private var contentCreated = false
  private var timer: NSTimer?
  private var ballTimer: NSTimer?
  private var deviceMulti: Int = 1
  private var cloudCounter: Int = 0
  private var zIndex: CGFloat = 1.0
  private var middleNodePositionX: CGFloat = 0
  private var middleNodePositionY: CGFloat = 0
  lazy private var item: Item = Item()
  lazy private var audioSession: AudioSession = AudioSession()
  
  override func didMoveToView(view: SKView) {
    if !self.contentCreated {
      self.contentCreated = true
      self.createSceneContents()
    }
  }
  
  private func createSceneContents() {
    switch UIDevice.currentDevice().userInterfaceIdiom {
    case .Phone:
      deviceMulti = 1
    default:
      deviceMulti = 2
    }
    
    middleNodePositionX = self.frame.size.width/2
    middleNodePositionY = self.frame.size.height/4.1
    zIndex = 100
    cloudCounter = 0
    self.backgroundColor = SKColor(red: 0.388, green: 0.851, blue: 0.855, alpha: 1)
    self.scaleMode = SKSceneScaleMode.AspectFit
    item.mainMenuCurrentScene = true
    timer = NSTimer(timeInterval: 10.0, target: self, selector: #selector(updateWithTimer), userInfo: nil, repeats: true)
    ballTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(updateBallWithTimer), userInfo: nil, repeats: true)
    
    self.addCloud()
    self.addChild(self.newTitleNode())
    self.addChild(self.newBeginNode())
    self.addChild(self.newScoreNode())
    self.addChild(self.newSoundNode())
    
  }
  
  func launchItem() {
    self.addChild(item.addRandomItem(self.size))
    item.initPhysics()
  }
  
  func toggleSound() {
    if(!audioSession.toggleAudioSettings()) {
      soundNode.alpha = 0.5
    } else {
      soundNode.alpha = 1
    }
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      let node = self.nodeAtPoint(location)
      if let nodeName = node.name, let node = node as? SKSpriteNode {
      switch nodeName {
      case "Begin":
        self.change(node:node, to: "Begin-Button-Selected")
        if let playSound = audioSession.playSound("Click_Down.mp3") {
          self.runAction(playSound)
        }
      case "Score":
        self.change(node:node, to: "Leaderboard-Button-Selected")
        if let playSound = audioSession.playSound("Click_Down.mp3") {
          self.runAction(playSound)
        }
        case "Sound":
          self.change(node:node, to: "Sound-Button-Selected")
          if let playSound = audioSession.playSound("Click_Down.mp3") {
            self.runAction(playSound)
        }
        case "More":
          self.change(node:node, to: "More-Games-Button-Selected")
          if let playSound = audioSession.playSound("Click_Down.mp3") {
            self.runAction(playSound)
        }
      default:
        break
      }
      }
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      let node = self.nodeAtPoint(location)
      if let nodeName = node.name, let node = node as? SKSpriteNode {
        switch nodeName {
        case "Begin":
          self.change(node:node, to: "Begin-Button")
        case "Score":
          self.change(node:node, to: "Leaderboard-Button")
        case "Sound":
          self.change(node:node, to: "Sound-Button")
        case "More":
          self.change(node:node, to: "More-Games-Button")
        default:
          break
        }
      }
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      let node = self.nodeAtPoint(location)
      if let nodeName = node.name, let node = node as? SKSpriteNode {
        switch nodeName {
        case "Begin":
          self.change(node:node, to: "Begin-Button")
          if let playSound = audioSession.playSound("Click_Up.mp3") {
            self.runAction(playSound)
          }
          timer?.invalidate()
          timer = nil
          ballTimer?.invalidate()
          ballTimer = nil
          let gameScene = GameScene()
            self.view?.presentScene(gameScene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1.0))
          
        case "Score":
          self.change(node:node, to: "Leaderboard-Button")
          if let playSound = audioSession.playSound("Click_Up.mp3") {
            self.runAction(playSound)
          }
          let gvc = GameViewController()
          gvc.showGameCenterLeaderboard()
        case "Sound":
          self.change(node:node, to: "Sound-Button")
          self.toggleSound()
        case "More":
          self.change(node:node, to: "More-Games-Button")
          if let playSound = audioSession.playSound("Click_Up.mp3") {
            self.runAction(playSound)
          }
        default:
          break
        }
      }
    }
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    guard let touches = touches else { return }
    for touch in touches {
      let location = touch.locationInNode(self)
      let node = self.nodeAtPoint(location)
      if let nodeName = node.name, let node = node as? SKSpriteNode {
        switch nodeName {
        case "Begin":
          self.change(node:node, to: "Begin-Button")
        case "Score":
          self.change(node:node, to: "Leaderboard-Button")
        case "Sound":
          self.change(node:node, to: "Sound-Button")
        case "More":
          self.change(node:node, to: "More-Games-Button")
        default:
          break
        }
      }
    }
  }
  
  func newTitleNode() -> SKLabelNode {
    let titleNode = SKLabelNode(fontNamed:"Helvetica Neue")
  titleNode.text = "Juggler"
  titleNode.name = "Title"
  titleNode.fontSize = 76 * CGFloat(deviceMulti)
  titleNode.zPosition = zIndex
  titleNode.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height/1.3)
  return titleNode
  }
  
  func newBeginNode() -> SKSpriteNode {
  let beginNode = SKSpriteNode(imageNamed:"Begin-Button")
  beginNode.name = "Begin"
  beginNode.zPosition = zIndex
  beginNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
  return beginNode
  }
  
  func newScoreNode() -> SKSpriteNode {
  let scoreNode = SKSpriteNode(imageNamed: "Leaderboard-Button")
  scoreNode.name = "Score"
  scoreNode.zPosition = zIndex
  scoreNode.position = CGPointMake(middleNodePositionX - (self.frame.size.width/6.38509316770186), middleNodePositionY)
  return scoreNode;
  }
  
  func newSoundNode() -> SKSpriteNode {
  soundNode.name = "Sound"
  soundNode.zPosition = zIndex
  soundNode.position = CGPointMake(middleNodePositionX + (self.frame.size.width/6.38509316770186), middleNodePositionY)
  if !audioSession.audioSessionIsActive {
    soundNode.alpha = 0.5
  }
    return soundNode
  }
  
  func change(node node: SKSpriteNode, to newImage: String) {
    let changeImage = SKAction.setTexture(SKTexture(imageNamed: newImage))
    node.runAction(changeImage)
  }
  
  func updateWithTimer(timer: NSTimer) {
    if cloudCounter <= 3 {
      self.addCloud()
    }
  }
  
  func updateBallWithTimer(timer: NSTimer) {
    self.launchItem()
  }
  
  override func didSimulatePhysics() {
    self.enumerateChildNodesWithName("item") { (node, void) in
      if node.position.y < 0 {
        node.removeFromParent()
      }
    }
  }
  
  func addCloud() {
    cloudCounter += 1
    let cloudArray = ["Cloud1", "Cloud2", "Cloud3"]
    let cloud = SKSpriteNode(imageNamed: cloudArray.random())
    cloud.position = CGPointMake((0 - cloud.frame.size.width), CGFloat(Float.random(lower: 0, upper: Float(self.size.height))))
    cloud.name = "Cloud"
    cloud.zPosition = zIndex - 10
    self.addChild(cloud)
    cloud.runAction(SKAction.moveToX(self.size.width + cloud.size.width, duration: Double.random(lower: 15, upper: 40))) {
      cloud.removeFromParent()
      self.cloudCounter -= 1
    }
  }
  
}
