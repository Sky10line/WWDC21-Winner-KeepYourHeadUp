//
//  GameScene.swift
//
//
//  Created by Rodrigo Ryo Aoki on 04/04/21.
//

import SpriteKit
import Foundation
import PlaygroundSupport

public class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var player: Player!
    public var runInLoop: (() -> Void) = {}
    
    private var carBarrier: SKSpriteNode!
    private var treeTrunk: SKSpriteNode!
    private var bigTree: SKSpriteNode!
    private var positionToCamera: CGPoint!
    
    private var win: Bool = false
    private var endAssessment: (() -> Void) = {}
    private var gameOverAssessmet: (() -> Void) = {}
    
    public override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        createBackground()
        
        let player = createPlayer()
        self.player = player
        preparePlayer()
        
        createObst1()
        createObst2()
        createObst3()
        
        createEnding()
        
        createCamera()
    }
    
    private func createFase2() {
        
    }
    
    public func setLoopFunc(loopFunc: @escaping (() -> Void)) {
        runInLoop = loopFunc
    }
    
    public override func update(_ currentTime: TimeInterval) {
        DispatchQueue.main.async { [self] in
            
            runInLoop()
            
            if(!win) {
                self.camera?.run(SKAction.move(to: CGPoint(x: player.position.x, y: player.position.y + 250) , duration: 0.2))
            }
        }
    }

    public func getPlayer() -> Player{
        return self.player
    }
    
    public func getBarrier() -> SKSpriteNode {
        return carBarrier
    }
    
    public func getTrunk() -> SKSpriteNode {
        return treeTrunk
    }
    
    public func getTree() -> SKSpriteNode {
        return bigTree
    }
    
//    private enum backgroundImage {
//        case
//    }
    
    private func createBackground(){
        let floor = SKSpriteNode(texture: SKTexture(imageNamed: "SceneSwiftChallengeFloorRec"))
        floor.setScale(1.5)
        floor.zPosition = 0
        floor.name = "Floor"
        floor.position = CGPoint(x: frame.midX+1000, y: frame.midY-450)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        
        if let pb = floor.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.floor
            pb.contactTestBitMask = Bitmasks.player
        }
        addChild(floor)
        
        let bg = SKSpriteNode(texture: SKTexture(imageNamed: "BackgroundOriginal"))
        bg.setScale(1.5)
        bg.zPosition = -10
        bg.position = CGPoint(x: frame.midX+1000, y: frame.midY + 450)
        
        addChild(bg)
    }
    
    private func createObst1(){
        let bar = SKSpriteNode(texture: SKTexture(imageNamed: "obs1"), size: CGSize(width: 20, height: 7))
        bar.setScale(10)
        bar.zPosition = 0
        bar.position = CGPoint(x: frame.minX+350, y: frame.minY + 360)
        bar.name = "Obstacle"
        bar.physicsBody = SKPhysicsBody(rectangleOf: bar.size)
        
        if let pb = bar.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.obstacle
            pb.collisionBitMask = Bitmasks.floor + Bitmasks.player
            pb.contactTestBitMask = Bitmasks.player
        }
        carBarrier = bar
        addChild(carBarrier)
        
        let weight = SKSpriteNode(texture: SKTexture(imageNamed: "obs1-2"), size: CGSize(width: 7, height: 20))
        weight.setScale(50)
        weight.zPosition = 0
        weight.position = CGPoint(x: frame.minX+350, y: frame.minY+1250)
        weight.name = "Obstacle"
        weight.physicsBody = SKPhysicsBody(texture: weight.texture!, size: weight.size)
        
        if let pb = weight.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.obstacle
            pb.collisionBitMask = Bitmasks.floor + Bitmasks.player
            pb.contactTestBitMask = Bitmasks.player
        }
        addChild(weight)
    }
    
    private func createObst2() {
        let trunk = SKSpriteNode(texture: SKTexture(imageNamed: "treeTrunk"), size: CGSize(width: 10, height: 25))
        trunk.setScale(10)
        trunk.zPosition = 0
        trunk.position = CGPoint(x: frame.minX + 1500, y: frame.minY+450)
        trunk.name = "Obstacle"
        trunk.physicsBody = SKPhysicsBody(texture: trunk.texture!, size: trunk.size)
        
        if let pb = trunk.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.obstacle
            pb.collisionBitMask = Bitmasks.floor + Bitmasks.player
            pb.contactTestBitMask = Bitmasks.player
        }
        treeTrunk = trunk
        player.setDodgebleObstacle(obstacle: treeTrunk)
        addChild(treeTrunk)
        
        let rock = SKSpriteNode(texture: SKTexture(imageNamed: "rock"), size: CGSize(width: 20, height: 20))
        rock.setScale(7)
        rock.zPosition = 1
        rock.position = CGPoint(x: frame.minX + 1550, y: frame.minY+395)
        rock.name = "Obstacle"
        rock.physicsBody = SKPhysicsBody(texture: rock.texture!, size: CGSize(width: 5, height: 5))
        
        if let pb = rock.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.obstacle
            pb.collisionBitMask = Bitmasks.floor + Bitmasks.player
            pb.contactTestBitMask = Bitmasks.player
        }
        
          addChild(rock)
    }
    
    private func createObst3(){
        let trunk = SKSpriteNode(texture: SKTexture(imageNamed: "bigTree"), size: CGSize(width: 20, height: 35))
        trunk.setScale(20)
        trunk.zPosition = 0
        trunk.position = CGPoint(x: frame.minX + 2800, y: frame.minY+675)
        trunk.name = "Obstacle"
        trunk.physicsBody = SKPhysicsBody(texture: trunk.texture!, size: trunk.size)
        
        if let pb = trunk.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.obstacle
            pb.collisionBitMask = Bitmasks.floor + Bitmasks.player
            pb.contactTestBitMask = Bitmasks.player
        }
        
        bigTree = trunk
        player.setDodgebleObstacle(obstacle: bigTree)
        
        addChild(bigTree)
    }
    
    private func createEnding() {
        let templeSign = SKSpriteNode(texture: SKTexture(imageNamed: "templeSign"), size: CGSize(width: 20, height: 20))
        templeSign.setScale(10)
        templeSign.zPosition = -2
        templeSign.position = CGPoint(x: frame.minX + 3700, y: frame.minY+427)
        templeSign.name = "End Sign"
        templeSign.physicsBody = SKPhysicsBody(rectangleOf: templeSign.size)
        
        if let pb = templeSign.physicsBody {
            pb.affectedByGravity = false
            pb.isDynamic = false
            pb.categoryBitMask = Bitmasks.endSign
            pb.collisionBitMask = 0
            pb.contactTestBitMask = Bitmasks.player
        }
        addChild(templeSign)
        
        let arrowSign = SKSpriteNode(texture: SKTexture(imageNamed: "signRight"), size: CGSize(width: 20, height: 20))
        arrowSign.setScale(10)
        arrowSign.zPosition = -2
        arrowSign.position = CGPoint(x: frame.minX + 3950, y: frame.minY+427)
        
        addChild(arrowSign)
        
        let label = SKLabelNode(text: "And then Charlie reached his goal by becoming a Master Developer and people who didn't believe in him before came to respect him and believe that they were wrong about him. \n\n During our journey, obstacles will appear, one different from the other, with different ways of solving and in the midst of these difficulties there will be times when we will think about giving up, other people may even say that you are incapable or that you are not good enough to do something. But if we persist in reaching our goal and believe in ourselves, anything is possible, even our wildest dreams. \n \nDreaming is the best thing we do, because of these dreams that are worth insisting on and always keep your head up.")
        label.position = CGPoint(x: frame.minX + 3850, y: frame.minY+827)
        label.fontName = "SF Pro Display-Bold"
        label.fontSize = 20
        label.color = .black
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 500
        label.lineBreakMode = .byCharWrapping
        label.verticalAlignmentMode = .center
        label.alpha = 0
        label.name = "EndLabel"
                
        addChild(label)
    }
    
    public func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Floor" || contact.bodyB.node?.name == "Floor" {
            self.player.setOnAir(active: true)
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Obstacle" || contact.bodyB.node?.name == "Obstacle" {
              gameOver() 
        }
        else if contact.bodyA.node?.name == "Floor" || contact.bodyB.node?.name == "Floor" {
            self.player.setOnAir(active: false)
        }
        else if contact.bodyA.node?.name == "End Sign" || contact.bodyB.node?.name == "End Sign" {
            wonGame()
        }
    }
    
    private func wonGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            win = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [self] in
                endLabel()
                endAssessment()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    player.hit()
                }
            }
        }
    }
        
    public func setAssessmentPassFunc(assessmentFunc: @escaping (() -> Void)) {
        self.endAssessment = assessmentFunc
    }

    private func endLabel() {
        let label = childNode(withName: "EndLabel")
        label?.run(SKAction.fadeAlpha(to: 1, duration: 7))
    }
        
    private func gameOver() {
        player.hit()
        self.gameOverAssessmet()
    }
        
    public func setAssessmentFailFunc(assessmentFunc: @escaping (() -> Void)) {
        self.gameOverAssessmet = assessmentFunc
    }
    
    private func preparePlayer() {
        resetPosPlayer()
        addChild(self.player)
    }
    
    private func resetPosPlayer() {
        self.player.setPos(Pos: CGPoint(x: frame.midX-1050, y: frame.midY-200))
    }
    
    private func createPlayer() -> Player{
        let player = Player()
        return player
    }
    
    private func createCamera() {
        let cam = SKCameraNode()
        self.camera = cam
        self.camera?.position = CGPoint(x: player.position.x, y: player.position.y + 250)
        addChild(self.camera!)
    }
}

