//
//  GameScene.swift
//  Archer Run
//
//  Created by Carlos Diez on 6/28/16.
//  Copyright (c) 2016 Carlos Diez. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None:        UInt32 = 0          // 0000
    static let Player:      UInt32 = 0b1        // 0001
    static let Obstacle:    UInt32 = 0b10       // 0010
    static let Coin:        UInt32 = 0b100      // 0100
    static let Floor:       UInt32 = 0b1000     // 1000
    static let Arrow:       UInt32 = 0b1001    // 1001
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GKStateMachine!
    var gameOverState: GKState!
    var playingState: GKState!
    var startingState: GKState!
    
    var currentLevelHolder: String = "levelHolder1"
    var fixedDelta: CFTimeInterval = 1.0/60.0
    var lastUpdateTime: CFTimeInterval = 0
    var randomInterval: CGFloat!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)m"
        }
    }
    var timer: CFTimeInterval = 0
    
    var archer: Archer!
    var clouds: SKEmitterNode!
    var gameOverScreen: SKSpriteNode!
    var invisibleGround: SKSpriteNode!
    var levelHolder1: SKSpriteNode!
    var levelHolder2: SKSpriteNode!
    var mountains1: SKSpriteNode!
    var mountains2: SKSpriteNode!
    var obstacleScrollLayer: SKNode!
    var playAgainButton: MSButtonNode!
    var startGroundLarge: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var startMountains: SKSpriteNode!
    var startingScrollLayer: SKNode!
    var startTreesBack: SKSpriteNode!
    var startTreesFront: SKSpriteNode!
    var treesBack1: SKSpriteNode!
    var treesBack2: SKSpriteNode!
    var treesFront1: SKSpriteNode!
    var treesFront2: SKSpriteNode!
    var water: SKSpriteNode!
    var water2: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        archer = Archer()
        addChild(archer)
        
        clouds = self.childNodeWithName("clouds") as! SKEmitterNode
        gameOverScreen = self.childNodeWithName("gameOverScreen") as! SKSpriteNode
        invisibleGround = self.childNodeWithName("//invisibleGround") as! SKSpriteNode
        levelHolder1 = self.childNodeWithName("levelHolder1") as! SKSpriteNode
        levelHolder2 = self.childNodeWithName("levelHolder2") as! SKSpriteNode
        mountains1 = self.childNodeWithName("mountains1") as! SKSpriteNode
        mountains2 = self.childNodeWithName("mountains2") as! SKSpriteNode
        obstacleScrollLayer = self.childNodeWithName("obstacleScrollLayer")
        playAgainButton = self.childNodeWithName("//playAgainButton") as! MSButtonNode
        startGroundLarge = self.childNodeWithName("//startGroundLarge") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        startMountains = self.childNodeWithName("startMountains") as! SKSpriteNode
        startingScrollLayer = self.childNodeWithName("startingScrollLayer")
        startTreesBack = self.childNodeWithName("startTreesBack") as! SKSpriteNode
        startTreesFront = self.childNodeWithName("startTreesFront") as! SKSpriteNode
        treesBack1 = self.childNodeWithName("treesBack1") as! SKSpriteNode
        treesBack2 = self.childNodeWithName("treesBack2") as! SKSpriteNode
        treesFront1 = self.childNodeWithName("treesFront1") as! SKSpriteNode
        treesFront2 = self.childNodeWithName("treesFront2") as! SKSpriteNode
        water = self.childNodeWithName("//water") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        
        clouds.advanceSimulationTime(120)
        
        setupGroundPhysics()
        
        gameOverState = GameOverState(scene: self)
        playingState = PlayingState(scene: self)
        startingState = StartingState(scene: self)
        
        gameState = GKStateMachine(states: [startingState, playingState, gameOverState])
        
        randomInterval = CGFloat.random(min: 0.3, max: 1.5)
        
        playAgainButton.selectedHandler = {
            if let scene = GameScene(fileNamed:"GameScene") {
                let skView = self.view!
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
        
        gameState.enterState(StartingState)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* Get references to bodies involved in collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        let categoryA = nodeA.physicsBody?.categoryBitMask
        let categoryB = nodeB.physicsBody?.categoryBitMask
        
        //Player contact with floor
        if  (categoryA == PhysicsCategory.Floor && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Floor) {
            
            if archer.state == .Dead { return }
            
            archer.run()
            
            if gameState.currentState is StartingState {
                gameState.enterState(PlayingState)
            }
            
        }
        
        //Player contacts obstacle
        if (categoryA == PhysicsCategory.Obstacle && categoryB == PhysicsCategory.Player) || (categoryA == PhysicsCategory.Player && categoryB == PhysicsCategory.Obstacle) {
            gameState.enterState(GameOverState)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if !(gameState.currentState is PlayingState) { return }
        
        let touch = touches.first
        let location = touch?.locationInNode(self)
        if location?.x > frame.width / 2 {
            // make the hero jump
            if archer.state == .Jumping { return }
            archer.jump()
        }
    }
   
    override func update(currentTime: NSTimeInterval) {
        
        /* Update states with deltaTime */
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameState.updateWithDeltaTime(deltaTime)
        
        /* Scroll water to make it look animated */
        scrollSprite(water, speed: 0.8)
        scrollSprite(water2, speed: 0.8)
    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func setupGroundPhysics() {
        startGroundLarge.physicsBody = SKPhysicsBody(texture: startGroundLarge!.texture!, size:startGroundLarge.size)
        startGroundLarge.physicsBody?.affectedByGravity = false
        startGroundLarge.physicsBody?.dynamic = false
        startGroundLarge.physicsBody?.restitution = 0
        startGroundLarge.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        startGroundLarge.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        startGroundLarge.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        levelHolder1.physicsBody = SKPhysicsBody(texture: levelHolder1!.texture!, size: levelHolder1.size)
        levelHolder1.physicsBody?.affectedByGravity = false
        levelHolder1.physicsBody?.dynamic = false
        levelHolder1.physicsBody?.restitution = 0
        levelHolder1.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        levelHolder1.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        levelHolder1.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        levelHolder2.physicsBody = SKPhysicsBody(texture: levelHolder2!.texture!, size: levelHolder2.size)
        levelHolder2.physicsBody?.affectedByGravity = false
        levelHolder2.physicsBody?.dynamic = false
        levelHolder2.physicsBody?.restitution = 0
        levelHolder2.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        levelHolder2.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        levelHolder2.physicsBody?.collisionBitMask = PhysicsCategory.Player
        
        invisibleGround.physicsBody = SKPhysicsBody(rectangleOfSize: invisibleGround.size)
        invisibleGround.physicsBody?.affectedByGravity = false
        invisibleGround.physicsBody?.dynamic = false
        invisibleGround.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        invisibleGround.physicsBody?.contactTestBitMask = PhysicsCategory.None
        invisibleGround.physicsBody?.collisionBitMask = PhysicsCategory.Player
    }
}
