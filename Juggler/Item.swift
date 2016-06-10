//
//  Item.swift
//  Juggler
//
//  Created by Evan Lewis on 6/9/16.
//  Copyright © 2016 Evan Lewis. All rights reserved.
//

import Foundation
import SpriteKit

enum Categories: UInt32 {
  case itemCategory
  case fingerCategory
}

class Item {
  
  var mainMenuCurrentScene: Bool = false
  
  var ball: SKNode?
  
  private var item: SKNode
  private var randomItemsAdded: Int
  private var counter: Int
  
  private var ballLaunchSpeedXMenu: CGFloat
  private var ballLaunchSpeedYMenu: CGFloat
  private var ballLaunchSpeedXGame: CGFloat
  private var ballLaunchSpeedYGame: CGFloat
  private var ballRadius: CGFloat
  private var bowlingBallRadius: CGFloat
  private var deviceMulti: CGFloat

  init() {
    randomItemsAdded = 0
    counter = 0
    item = SKNode()
    
    switch UIDevice.currentDevice().userInterfaceIdiom {
    case .Phone:
      ballLaunchSpeedXMenu = 4.4;
      ballLaunchSpeedYMenu = 26.0;
      ballLaunchSpeedXGame = 4.4;
      ballLaunchSpeedYGame = 2.0;
      ballRadius = 12.0;
      deviceMulti = 1;
    default:
      ballLaunchSpeedXMenu = 10.16;
      ballLaunchSpeedYMenu = 72.4;
      ballLaunchSpeedXGame = 8.8;
      ballLaunchSpeedYGame = 6.0;
      ballRadius = 24.0;
      deviceMulti = 2;
    }
  }


  func addRandomItem(size: CGSize) -> SKNode {
  
  let objectArray = ["ball", "ball", "ball", "ball", "bowlingBall", "pineapple", "torch"]
  
  if (!self.mainMenuCurrentScene) {
    item.name = objectArray.random();
  }
  
    if let itemName = item.name {
    
    switch itemName {
    case "ball":
      item = self.createBall()
    case "bowlingBall":
      item = self.createBowlingBall()
    case "pineapple":
      item = self.createPineapple()
    case "torch":
      item = self.createTorch()
    }
    }
  
  let sides = [size.width - size.width/1.05, size.width/1.01];
  let sidesBeneath = [size.width/6.4, size.width - size.width/6.4];
  
  if (self.mainMenuCurrentScene) {
    item.position = CGPointMake(sidesBeneath.random(), 20);
    item.zPosition = 95;
  } else {
    item.position = CGPointMake(sides.random(), CGFloat(Float.random(lower: Float(size.height/1.01), upper: Float(size.height/1.6))))
    item.zPosition = 100;
  }
    
    switch counter {
    case 10:
      if (randomItemsAdded <= 7) {
        randomItemsAdded += 1
      }
    case 20:
      if (randomItemsAdded <= 11) {
        randomItemsAdded += 1
      }
    case 30:
      if (randomItemsAdded <= 15) {
        randomItemsAdded += 1
      }
    default:
      break
  }
    counter += 1
  
  return item;
}

 func initPhysics() {
  let weightTypes: [CGFloat] = [0.3, 0.6, 0.8]
  
  if let itemName = item.name {
    switch itemName {
    case "ball":
      item.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        item.physicsBody?.linearDamping = weightTypes.random()
    case "bowlingBall":
      item.physicsBody = SKPhysicsBody(circleOfRadius: bowlingBallRadius)
        item.physicsBody?.linearDamping = 1.1
        item.physicsBody?.applyAngularImpulse(0.01)
    case "pineapple":
    let polygonPath = UIBezierPath()
    polygonPath.moveToPoint(CGPointMake(-1, 18.5))
    polygonPath.moveToPoint(CGPointMake(6.35, 14.97))
    polygonPath.moveToPoint(CGPointMake(10.89, 5.72))
    polygonPath.moveToPoint(CGPointMake(10.89, -5.72))
    polygonPath.moveToPoint(CGPointMake(6.35, -14.97))
    polygonPath.moveToPoint(CGPointMake(-1, -18.5))
    polygonPath.moveToPoint(CGPointMake(-8.35, -14.97))
    polygonPath.moveToPoint(CGPointMake(-12.89, -5.72))
    polygonPath.moveToPoint(CGPointMake(-12.89, 5.72))
    polygonPath.moveToPoint(CGPointMake(-8.35, 14.97))
    polygonPath.closePath()
    
    item.physicsBody = SKPhysicsBody.init(polygonFromPath: polygonPath.CGPath)
    item.physicsBody?.linearDamping = 0.5
   case "torch":
    item.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(14, 56))
    item.physicsBody?.linearDamping = 0.4;
    item.physicsBody?.applyAngularImpulse(0.01)
  }
  }
  item.name = "item"
  item.physicsBody?.mass = 0.020106 / deviceMulti;
  item.physicsBody?.density = 0.999990 / deviceMulti;
  item.physicsBody?.restitution = 0.0
  item.physicsBody?.categoryBitMask = Categories.itemCategory.rawValue
  item.physicsBody?.contactTestBitMask = Categories.fingerCategory.rawValue
  item.physicsBody?.collisionBitMask = Categories.fingerCategory.rawValue
  if (self.mainMenuCurrentScene) {
    if (item.position.x <= 160) {
      item.physicsBody?.applyImpulse(CGVector(dx: ballLaunchSpeedXMenu, dy: ballLaunchSpeedYMenu))
    } else {
      item.physicsBody?.applyImpulse(CGVector(dx: -ballLaunchSpeedXMenu, dy: ballLaunchSpeedYMenu))
    }
  } else {
    if (item.position.x < 100) {
      item.physicsBody?.applyImpulse(CGVector(dx: ballLaunchSpeedXGame, dy: ballLaunchSpeedYGame))
    } else {
      item.physicsBody?.applyImpulse(CGVector(dx: -ballLaunchSpeedXGame, dy: ballLaunchSpeedYGame))
    }
  }
}

 func createBall() -> SKNode {
  let circlePath = UIBezierPath.init(ovalInRect: CGRect(x: -ballRadius, y: -ballRadius, width: CGFloat(ballRadius * 2), height: CGFloat(ballRadius * 2)))
  
  let orangeColor = SKColor(red: 1, green: 0.631, blue: 0, alpha: 1)
  let redColor = SKColor(red: 1, green: 0.176, blue: 0.333, alpha: 1)
  let blueColor = SKColor(red: 0.259, green: 0.804, blue: 0, alpha: 1)
  let purpleColor = SKColor(red: 0.659, green: 0.337, blue: 0.898, alpha: 1)
  let crimsonColor = SKColor(red: 0.719, green: 0.156, blue: 0.33, alpha: 1)
  let goldColor = SKColor(red: 0.918, green: 0.863, blue: 0.059, alpha: 1)
  
  let colorArray = [orangeColor, redColor, blueColor, purpleColor, crimsonColor, goldColor]
  let ballItem = SKShapeNode()
  ballItem.path = circlePath.CGPath
  ballItem.fillColor = colorArray.random()
  ballItem.name = "ball"
  ballItem.lineWidth = 0.0
  return ballItem;
}

 func createBowlingBall() -> SKNode {
  let bowlingBall = SKSpriteNode(imageNamed: "BowlingBall")
  bowlingBallRadius = 18.0
  bowlingBall.name = "bowlingBall"
  return bowlingBall
}

  func createPineapple() -> SKNode {
  let pineapple = SKSpriteNode(imageNamed: "Pineapple")
  pineapple.name = "pineapple";
  return pineapple;
}

 func createTorch() -> SKNode {
  let torch = SKSpriteNode(imageNamed: "Torch")
  torch.name = "torch";
  return torch;
}
}


extension Array {
  func random() -> Element {
    let randomIndex = Int(rand()) % count
    return self[randomIndex]
  }
}

public extension Float {
  public static func random(lower lower: Float, upper: Float) -> Float {
    let r = Float(arc4random()) / Float(UInt32.max)
    return (r * (upper - lower)) + lower
  }
}

public extension Double {
  public static func random(lower lower: Double, upper: Double) -> Double {
    let r = Double(arc4random()) / Double(UInt64.max)
    return (r * (upper - lower)) + lower
  }
}
