//
//  GameScene.swift
//  Game Jam
//
//  Created by Andrew Zhou on 6/27/16.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum GameState {
    case Title, Level1, GameOver
}

class GameScene: SKScene {
    
    //var characterNode: SKSpriteNode!
    //var characterReferenceNode: SKReferenceNode!
    var player: MSReferenceNode!
    var touchNode: SKNode!
    var isTouched = false
    var touchLocation: CGPoint?
    var levelNode: SKNode!
    var cameraTarget: SKNode?
    
    override func didMoveToView(view: SKView) {
        //characterNode = childNodeWithName("//player") as! SKSpriteNode
        //characterReferenceNode = childNodeWithName("playerNode") as! SKReferenceNode
        touchNode = childNodeWithName("touchNode")
        levelNode = childNodeWithName("levelNode")
        
        let resourcePlayerPath = NSBundle.mainBundle().pathForResource("Player", ofType: "sks")
        player = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePlayerPath!))
        player.position = CGPoint(x: 284, y: 160)
        
        addChild(player)
        
        cameraTarget = player.avatar
        
        //print("ct: \(cameraTarget?.position), cn: \(characterReferenceNode.position)")
        cameraTarget = player.avatar
        //print("ct: \(cameraTarget?.position), cn: \(characterReferenceNode.position)")
        
        
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouched = true
        for touch in touches {
            touchLocation = touch.locationInNode(self)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouched = false
        for touch in touches {
            touchLocation = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        
        if let loc = touchLocation {
            if(loc.x < player.avatar.position.x + 284 && isTouched) {
                player.avatar.physicsBody?.applyImpulse(CGVectorMake(-1, 0))
            }
            if(loc.x >= player.avatar.position.x + 284 && isTouched){
                player.avatar.physicsBody?.applyImpulse(CGVectorMake(1, 0))
            }
        }
        
        let velX = player.avatar.physicsBody?.velocity.dx ?? 0
        if(velX > 200) {
            player.avatar.physicsBody?.velocity.dx = 200
        } else if(velX < -200) {
                player.avatar.physicsBody?.velocity.dx = -200
        }
        
        if let ct = cameraTarget {
            var cameraPoint = CGPoint(x:ct.position.x + 284, y:ct.position.y + 200)
            if cameraPoint.x <= 285 {
                cameraPoint.x = 285
            }
            if cameraPoint.y <= 200 {
                cameraPoint.y = 200
            }
            
            camera?.position = cameraPoint
            //print("ct: \(ct.position), cn: \(characterReferenceNode.position)")
        }
        //print(player.avatar.position)
    }
}
