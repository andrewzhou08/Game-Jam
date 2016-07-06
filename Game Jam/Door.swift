//
//  Door.swift
//  Game Jam
//
//  Created by Andrew Zhou on 7/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SpriteKit

class Door: SKSpriteNode {
    
    enum DoorState {
        case Open, Closed
    }
    
    var doorState: DoorState = .Closed {
        didSet {
            switch doorState{
            case .Open:
                let openingAnimation = SKAction(named: "DoorOpen")!
                runAction(openingAnimation)
                break
            case .Closed:
                let closingAnimation = SKAction(named: "DoorClose")!
                runAction(closingAnimation)
                break
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func toggleDoor() {
        if(doorState == .Closed) {doorState = .Open}
        else {doorState = .Closed}
    }
    
    func openDoor() {
        if(doorState == .Closed) {doorState = .Open}
    }
    
    func closeDoor() {
        if(doorState == .Open) {doorState = .Closed}
    }
}