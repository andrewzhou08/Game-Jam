//
//  Button.swift
//  Game Jam
//
//  Created by Andrew Zhou on 7/5/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SpriteKit

class Button:SKSpriteNode {
    
    enum ButtonState {
        case Unpressed, Pressed
    }
    
    var textures:[SKTexture] = []
    var door: Door!
    
    var buttonState = ButtonState.Unpressed {
        didSet {
            switch buttonState {
            case .Unpressed:
                self.texture = textures[0]
                door.closeDoor()
                break
            case .Pressed:
                self.texture = textures[1]
                door.openDoor()
                break
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        textures.append(SKTexture(imageNamed: "Button-Unpressed.png"))
        textures.append(SKTexture(imageNamed: "Button-Pressed.png"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textures.append(SKTexture(imageNamed: "Button-Unpressed.png"))
        textures.append(SKTexture(imageNamed: "Button-Pressed.png"))
    }
    
    func connectDoor(door: Door){
        self.door = door;
    }
    
    func toggleButtonState() {
        if(buttonState == .Unpressed) {buttonState = .Pressed}
        else {buttonState = .Unpressed}
        door.toggleDoor()
    }
    
    func pressButton() {
        if(buttonState == .Unpressed) {buttonState = .Pressed}
    }
    
    func unpressButton() {
        if(buttonState == .Pressed) {buttonState = .Unpressed}
    }
}