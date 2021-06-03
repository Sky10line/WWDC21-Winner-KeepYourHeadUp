//
//  Player.swift
//  
//
//  Created by Rodrigo Ryo Aoki on 04/04/21.
//

import Foundation
import SpriteKit
import GameplayKit

public class Player: SKSpriteNode{
    private let chacRun: [SKTexture] = [SKTexture(imageNamed: "run1"), SKTexture(imageNamed: "run2"), SKTexture(imageNamed: "run3")]
    private let chacJump = SKTexture(imageNamed: "jump")
    private let chacStepToSide = SKTexture(imageNamed: "stepToSide")
    private let chacStoped = SKTexture(imageNamed: "Chac-Stoped")
    private var dodgebleObstacles: [SKSpriteNode] = []
    
    private var startDodge = false
    private var isOnAir = false
    private var hitted = false
    
    init(){
        super.init(texture: chacStoped, color: UIColor.blue, size: CGSize(width: 100, height: 100))
        self.setScale(2)
        self.zPosition = 0
        self.name = "Player"
        setPhysicsBody()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPos(Pos: CGPoint){
        self.position = Pos
    }
    
    func removeCamera() -> SKCameraNode {
        let cam = self.children[0] as! SKCameraNode
        self.removeAllChildren()
        return cam
    }
    
    private func setPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        if let pb = self.physicsBody {
            pb.isDynamic = true
            pb.allowsRotation = false
            pb.friction = 0.1
            pb.categoryBitMask = Bitmasks.player
            pb.collisionBitMask = Bitmasks.floor + Bitmasks.obstacle
            pb.contactTestBitMask = Bitmasks.obstacle + Bitmasks.floor
        }
    }
    
    public func setDodgebleObstacle(obstacle: SKSpriteNode){
        dodgebleObstacles.append(obstacle)
    }
    
//      private func addCamera(camera: SKCameraNode){
//          camera.setScale(0.5)
//          camera.position.y += 100
//          self.addChild(camera)
//      }
    
    public func hasObstacleOnTheWay(obstacle: SKSpriteNode) -> Bool{
        if self.position.x > obstacle.position.x - 250 && self.position.x < obstacle.position.x {
            return true
        }
        return false
    }
    
    public func hit() {
        self.hitted = true
        self.removeAllActions()
        self.texture = chacStoped
    }
    
    public func startRun(){
        if !self.hasActions() && !isOnAir && !self.hitted {
            let walkAnimation = SKAction.animate(with: chacRun,
                                                 timePerFrame: 0.1)
            let array = SKAction.sequence([walkAnimation, SKAction.wait(forDuration: 0.15)])
            self.run(array, withKey: "Walking Animation")
            self.physicsBody?.velocity.dx = 250
        }
        else if self.physicsBody?.velocity.dx ?? 0 == 0 && self.physicsBody?.velocity.dy ?? 0 == 0 && isOnAir && !self.hitted{
            setOnAir(active: false)
            self.removeAllActions()
        }
    }
    
    public func setOnAir(active: Bool) {
        self.isOnAir = active
    }
    
    public func jump(){
        if !isOnAir && !self.hitted{
            self.removeAction(forKey: "Walking Animation")
            self.texture = chacJump
            self.physicsBody?.velocity = CGVector(dx: 500, dy: 800)
        }
    }
    
    public func doubleJump() {
        if !isOnAir && !self.hitted{
            self.removeAction(forKey: "Walking Animation")
            self.texture = chacJump
            self.physicsBody?.velocity = CGVector(dx: 300, dy: 800)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                self.physicsBody?.velocity = CGVector(dx: 500, dy: 800)
            }
            
        }
    }
    
    public func dodgeToSide() {
        if !isOnAir && !startDodge && !self.hitted{
            startDodge = true
            self.zPosition = 10
            
            let chacSequence = SKAction.sequence([SKAction.setTexture(chacStepToSide), SKAction.scale(to: CGFloat(2.3), duration: 0.3)])
            self.removeAction(forKey: "Walking Animation")
            self.run(chacSequence)
            
            for obstacle in dodgebleObstacles {
                obstacle.physicsBody?.categoryBitMask = 0
                obstacle.physicsBody?.contactTestBitMask = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                self.zPosition = 0
                
                if !self.hitted {
                    let chacSequenceBack = SKAction.sequence([SKAction.setTexture(chacStepToSide), SKAction.scale(to: CGFloat(2.0), duration: 0.3)])
                    self.removeAction(forKey: "Walking Animation")
                    self.run(chacSequenceBack)
                }
                
                setOnAir(active: false)
                
                for obstacle in dodgebleObstacles {
                    obstacle.physicsBody?.categoryBitMask = Bitmasks.obstacle
                    obstacle.physicsBody?.contactTestBitMask = Bitmasks.player
                }
                startDodge = false
            }
        }
    }
}
