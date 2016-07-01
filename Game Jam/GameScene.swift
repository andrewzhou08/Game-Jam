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
    
    var characterNode: SKSpriteNode!
    var touchNode: SKNode!
    var isTouched = false
    var touchLocation: CGPoint?
    
    override func didMoveToView(view: SKView) {
        characterNode = childNodeWithName("//player") as! SKSpriteNode
        touchNode = childNodeWithName("touchNode")
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
            if(loc.x < 284 && isTouched) {
                characterNode.physicsBody?.applyImpulse(CGVectorMake(-1, 0))
                print("loc: \(loc)")
            }
            if(loc.x >= 284 && isTouched){
                characterNode.physicsBody?.applyImpulse(CGVectorMake(1, 0))
                print("loc: \(loc)")
            }
        }
        
        let velX = characterNode.physicsBody?.velocity.dx ?? 0
        if(velX > 200) {
            characterNode.physicsBody?.velocity.dx = 200
        } else if(velX < -200) {
                characterNode.physicsBody?.velocity.dx = -200
        }
    }
}
