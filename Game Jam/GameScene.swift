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
    var levelNumber = 1

    var scrollLayer: SKNode!
    var levelNode: SKNode!
    var cameraTarget: SKNode?
    var restartButton: MSButtonNode!
    var level: Level!
    var buttonNode: [Button]!
    
    //Called when moved to view
    override func didMoveToView(view: SKView) {
        
        levelNode = childNodeWithName("levelNode")
        scrollLayer = childNodeWithName("scrollLayer")
        restartButton = childNodeWithName("//restartButton") as! MSButtonNode
        
        let resourcePlayerPath = NSBundle.mainBundle().pathForResource("Player", ofType: "sks")
        player = MSReferenceNode(URL: NSURL (fileURLWithPath: resourcePlayerPath!))
        player.position = CGPoint(x: 284, y: 160)
        
        physicsWorld.contactDelegate = self
        
        addChild(player)
        
        cameraTarget = player.avatar
        
        if(levelNumber == 1){
            loadInitialLevel()
        }
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
        if(velX > 300 && isTouched) {
            player.avatar.physicsBody?.velocity.dx -= 5
        } else if(velX < -300 && isTouched) {
            player.avatar.physicsBody?.velocity.dx += 5
        }
        
        if let ct = cameraTarget {
            var cameraPoint = CGPoint(x:ct.position.x + 284, y:ct.position.y + 200)
            if cameraPoint.x <= 285 {
                cameraPoint.x = 285
            }
            if cameraPoint.y <= 200 {
                cameraPoint.y = 200
            }
            if cameraPoint.y >= 2200 {
                cameraPoint.y = 2200
            }
            
            camera?.position = cameraPoint
        }
        if(player.avatar.position.y < -1000) {
            die()
        }
        
        restartButton.selectedHandler = {
            self.die()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        //let nodeA = contactA.node as! SKSpriteNode
        //let nodeB = contactB.node as! SKSpriteNode
        
        if((contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) || (contactB.categoryBitMask == 1 && contactA.categoryBitMask == 2)) {
            let playerPoint = convertPoint(player.avatar.position, fromNode: player)
            let difference = playerPoint.y-16 - contact.contactPoint.y
            if(difference < 6 && difference > -6){
                canJump = true
                canSpring = true
            } else {
                canJump = false
            }
        }
        
        if((contactA.categoryBitMask == 1 && contactB.categoryBitMask == 4 && canSpring) || (contactB.categoryBitMask == 1 && contactA.categoryBitMask == 4 && canSpring)) {
            player.avatar.physicsBody?.applyImpulse(CGVectorMake(0, 100))
            canSpring = false
        }
        
        if((contactA.categoryBitMask == 1 && contactB.categoryBitMask == 16) || (contactB.categoryBitMask == 1 && contactA.categoryBitMask == 16)) {
            die()
        }
        if(contactA.categoryBitMask == 1 && contactB.categoryBitMask == 8) {
            let nodeB = contactB.node as! Button
            for button in buttonNode {
                if(button == nodeB) {
                    nodeB.pressButton()
                }
            }
        }
        if(contactA.categoryBitMask == 8 && contactB.categoryBitMask == 1) {
            let nodeA = contactA.node as! Button
            for button in buttonNode {
                if(button == nodeA) {
                    nodeA.pressButton()
                }
            }
        }
        if(contactA.categoryBitMask == 1 && contactB.categoryBitMask == 32 || contactA.categoryBitMask == 32 && contactB.categoryBitMask == 1) {
            levelNumber += 1
            loadLevel(levelNumber)
        }
        if(contactA.categoryBitMask == 1 && contactB.categoryBitMask == 64 || contactA.categoryBitMask == 64 && contactB.categoryBitMask == 1) {
            player.avatar.physicsBody?.applyImpulse(CGVectorMake(100,0))
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
    
    
    
    func loadInitialLevel() {
        let resourcePath = NSBundle.mainBundle().pathForResource("Level\(levelNumber)", ofType: "sks")
        let newLevel = Level (URL: NSURL (fileURLWithPath: resourcePath!))
        levelNode.addChild(newLevel)
        newLevel.addButtons()
        buttonNode = newLevel.buttonNode
        self.level = newLevel
        
        player.avatar.position = CGPoint(x: 284, y: 160)
    }
    
    func loadLevel(level: Int) {
        let skView = self.view as SKView!
        let scene = GameScene(fileNamed:"GameScene") as GameScene!
        scene.scaleMode = .AspectFit
        scene.levelNumber = levelNumber
        skView.presentScene(scene)
        
        let resourcePath = NSBundle.mainBundle().pathForResource("Level\(levelNumber)", ofType: "sks")
        let newLevel = Level(URL: NSURL (fileURLWithPath: resourcePath!))
        newLevel.addButtons()
        buttonNode = newLevel.buttonNode
        self.level = newLevel
        scene.levelNode.addChild(newLevel)
        
        scene.level = self.level
        
        scene.player.avatar.position = CGPoint(x: 284, y: 160)
    }
}
