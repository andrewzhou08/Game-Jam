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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var characterNode: SKSpriteNode!
    //var characterReferenceNode: SKReferenceNode!
    var player: MSReferenceNode!
    var isTouched = false
    var canJump = true
    var canSpring = true
    var touchLocation: CGPoint?
    var startTouchLocation: CGPoint?
    var endTouchLocation: CGPoint?

    var scrollLayer: SKNode!
    var levelNode: SKNode!
    var cameraTarget: SKNode?
    
    override func didMoveToView(view: SKView) {
        //characterNode = childNodeWithName("//player") as! SKSpriteNode
        //characterReferenceNode = childNodeWithName("playerNode") as! SKReferenceNode
        levelNode = childNodeWithName("levelNode")
        scrollLayer = childNodeWithName("scrollLayer")
        
        let resourcePlayerPath = NSBundle.mainBundle().pathForResource("Player", ofType: "sks")
        player = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePlayerPath!))
        player.position = CGPoint(x: 284, y: 160)
        
        physicsWorld.contactDelegate = self
        
        addChild(player)
        
        cameraTarget = player.avatar
        
        
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
        
        loadLevel1()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouched = true
        for touch in touches {
            touchLocation = touch.locationInView(view)
            startTouchLocation = touch.locationInView(view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.locationInView(view)
            
            //Jumping
            endTouchLocation = touch.locationInView(view)
            if(endTouchLocation!.y - startTouchLocation!.y <= -100 && canJump) {
                canJump = false
                player.avatar.physicsBody?.applyImpulse(CGVectorMake(0, 50))
                startTouchLocation = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouched = false
        for touch in touches {
            touchLocation = touch.locationInView(view)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        
        if let loc = touchLocation {
            if(loc.x < 284 && isTouched) {
                player.avatar.physicsBody?.applyImpulse(CGVectorMake(-1, 0))
            }
            if(loc.x >= 284 && isTouched){
                player.avatar.physicsBody?.applyImpulse(CGVectorMake(1, 0))
            }
        }
        
        let velX = player.avatar.physicsBody?.velocity.dx ?? 0
        if(velX > 300) {
            player.avatar.physicsBody?.velocity.dx = 300
        } else if(velX < -300) {
                player.avatar.physicsBody?.velocity.dx = -300
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
        }
        if(player.avatar.position.y < -1000) {
            die()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        //let nodeA = contactA.node as! SKSpriteNode
        //let nodeB = contactB.node as! SKSpriteNode
        
        if((contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) || (contactB.categoryBitMask == 1 && contactA.categoryBitMask == 2)) {
            canJump = true
            canSpring = true
        }
        
        if((contactA.categoryBitMask == 1 && contactB.categoryBitMask == 4 && canSpring) || (contactB.categoryBitMask == 1 && contactA.categoryBitMask == 4 && canSpring)) {
            player.avatar.physicsBody?.applyImpulse(CGVectorMake(0, 100))
            canSpring = false
            canJump = false
        }
        
        if((contactA.categoryBitMask == 1 && contactB.categoryBitMask == 16) || (contactB.categoryBitMask == 1 && contactA.categoryBitMask == 16)) {
            die()
        }
    }
    
    func die() {
        player.removeFromParent()
        let resourcePlayerPath = NSBundle.mainBundle().pathForResource("Player", ofType: "sks")
        player = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePlayerPath!))
        player.position = CGPoint(x: 284, y: 160)
        addChild(player)
        
        cameraTarget = player.avatar
    }
    
    
    
    func loadLevel1() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "sks")
        let newLevel = SKReferenceNode (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
    }
}
