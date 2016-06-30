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
    
    override func didMoveToView(view: SKView) {
        characterNode = childNodeWithName("//player") as! SKSpriteNode
        touchNode = childNodeWithName("touchNode")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if(touchedNode.name == "touchLeft") {
                print("Move left!")
            } else if(touchedNode.name == "touchRight") {
                print("Move right!")
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
