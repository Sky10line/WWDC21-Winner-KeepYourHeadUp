//#-hidden-code
//
//  main.swift
//
//
//  Created by Rodrigo Ryo Aoki on 04/04/21.
//
//#-end-hidden-code

/*:
This is Charlie. He always wanted to become a Developer, but no one ever belived him and made fun of his dream. Because of that he decided to become a Developer Master, a title given to those who find "The Swift Master Scroll", located inside of "Computing Temple", and get the knowledge written on it.
 
Help Charlie on this journey to become a Master Developer by writing the code for him to follow.
*/


//#-hidden-code
import SpriteKit
import PlaygroundSupport
import UIKit
import Foundation
import Book

let skView = SKView(frame: .zero)

let gameScene = GameScene(size: UIScreen.main.bounds.size)
gameScene.scaleMode = .aspectFill
skView.presentScene(gameScene)
//skView.showsFPS = true
let player = gameScene.getPlayer()
let barrier = gameScene.getBarrier()
let trunk = gameScene.getTrunk()
let tree = gameScene.getTree()



enum Obstacles : String, Codable{
    ///Obstacle is a car barrier
    /// - localizationKey: Obstacles.carBarrier
    case carBarrier
    
    ///Obstacle is a tree trunk
    /// - localizationKey: Obstacles.treeTrunk
    case treeTrunk
    
    ///Obstacle is a big tree
    /// - localizationKey: Obstacles.bigTree
    case bigTree
}


/// Returns true or false based on the selected obstacle as argument.
/// - localizationKey: hasObstacle(_: .)
func hasObstacle(_ obstacle: Obstacles) -> Bool {
    switch obstacle {
    case .carBarrier:
        return player.hasObstacleOnTheWay(obstacle: barrier)
    case .treeTrunk:
        return player.hasObstacleOnTheWay(obstacle: trunk)
    case .bigTree:
        return player.hasObstacleOnTheWay(obstacle: tree)
    }
}

func runCodeInLoop(function: @escaping (()->Void)){
    gameScene.setLoopFunc(loopFunc: function)
}

/// Charlie runs
/// - localizationKey: run()
func run() {
    player.startRun()
}

/// Charlie jumps
/// - localizationKey: jump()
func jump() {
    player.jump()
}

/// Charlie double jumps
/// - localizationKey: doubleJump()
func doubleJump() {
    player.doubleJump()
}

/// Charlie dodge to the side
/// - localizationKey: dodgeToSide()
func dodgeToSide() {
    player.dodgeToSide()
}

gameScene.setAssessmentPassFunc {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
        PlaygroundPage.current.assessmentStatus = .pass(message: """
            You did it despite the obstacles on the way!

            I hope you enjoyed the game experience on this Playground Book!
        """)
    }
}

gameScene.setAssessmentFailFunc {
    
    let hintsList = ["""
Maybe you could use the "if" statement with the function "hasObstacle(_ obstacle: .)" to pass through the obstacles with the actions (jump, double jump and dodge to side).
"""]
    PlaygroundPage.current.assessmentStatus = .none
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
        PlaygroundPage.current.assessmentStatus = .fail(hints: hintsList, solution:"""
    Try to use this code down below:

    run()
        if hasObstacle(.carBarrier) {
            jump()
        }
        if hasObstacle(.treeTrunk) {
            doubleJump()
        }
        if hasObstacle(.bigTree) {
            dodgeToSide()
        }
    """)
    }
}

//#-code-completion(everything, hide)
//#-code-completion(identifier, show, jump(), doubleJump(), dodgeToSide())
//#-code-completion(identifier, show, carBarrier, treeTrunk, bigTree, .)
//#-code-completion(identifier, show, hasObstacle(_:))
//#-code-completion(keyword, show, if)
//#-code-completion(identifier, show, run())

//#-end-hidden-code

runCodeInLoop {
    //#-hidden-code
    DispatchQueue.global().async {
        //#-end-hidden-code
        //Create the code to run
        //#-editable-code
        
        //#-end-editable-code
        //#-hidden-code
    }
    //#-end-hidden-code
}

//#-hidden-code
PlaygroundPage.current.liveView = skView
PlaygroundPage.current.wantsFullScreenLiveView = false
PlaygroundPage.current.liveView
//#-end-hidden-code
