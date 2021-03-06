//
//  Spike.swift
//  Archer Run
//
//  Created by Carlos Diez on 7/11/16.
//  Copyright © 2016 Carlos Diez. All rights reserved.
//

import SpriteKit

class Spike: SKSpriteNode {
    
    let spikeTexture: SKTexture? = SKTexture(imageNamed: "spikes")
    let spikeSize: CGSize = CGSize(width: 45, height: 45)
    let spikeColor: UIColor = UIColor.white
    
    init() {
        super.init(texture: spikeTexture, color: spikeColor, size: spikeSize)
        
        self.zPosition = 1
        self.setupPhysicsBody(spikeTexture!, size: spikeSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhysicsBody(_ texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}
