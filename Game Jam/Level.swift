//
//  Level.swift
//  Game Jam
//
//  Created by Andrew Zhou on 7/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKScene {
    
    var level = 1
    var buttonNodeReference: [SKReferenceNode]! = []
    var buttonNode: [Button] = []
    var buttonNumber = 1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        buttonNodeReference.append(childNodeWithName("buttonNode\(buttonNumber)") as! SKReferenceNode)
        
        for button in buttonNodeReference{
            let buttonTemp = button.childNodeWithName("buttonNode") as! Button
            buttonNode.append(buttonTemp)
        }
        
    }
}