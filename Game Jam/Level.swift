//
//  Level.swift
//  Game Jam
//
//  Created by Andrew Zhou on 7/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKReferenceNode, SKPhysicsContactDelegate {
    
    var level = 1
    var buttonNodeReference: [SKReferenceNode?] = []
    var buttonNode: [Button] = []
    var buttonNumber = 1
    var doorNumber = 1
    
    override init(URL url: NSURL?) {
        super.init(URL: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addButtons() {
        buttonNumber = 1
        doorNumber = 1
        while(true){
            if(childNodeWithName("//buttonNode\(buttonNumber)") as? SKReferenceNode == nil) {break}
            buttonNodeReference.append(childNodeWithName("//buttonNode\(buttonNumber)") as? SKReferenceNode)
            buttonNumber += 1
        }
        
        for button in buttonNodeReference{
            let buttonTemp = button!.childNodeWithName("//buttonNode") as! Button
            let doorReference = childNodeWithName("//doorNode\(doorNumber)")
            let doorSprite = doorReference?.childNodeWithName("//doorNode") as! Door
            buttonTemp.connectDoor(doorSprite)
            doorNumber += 1
            buttonNode.append(buttonTemp)
            print(buttonTemp)
        }
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
}