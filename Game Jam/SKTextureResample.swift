//
//  SKTextureResample.swift
//  Game Jam
//
//  Created by Andrew Zhou on 7/5/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import SpriteKit

class SKTextureResample: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.texture?.filteringMode = .Nearest
    }
}