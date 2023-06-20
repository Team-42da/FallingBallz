//
//  GameScene.swift
//  FallingBallz
//
//  Created by Greed on 2023/06/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var obstacleNumber : Int = 0
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        makeObstacle()
        
        self.enumerateChildNodes(withName: "//obstacle*") { (node, stop) in
            node.run(SKAction.moveBy(x: 0, y: self.frame.size.width * 0.1, duration: 0.1))
        }
    }
    
    func randomPosX() -> Int {
        let randomX = Int.random(in: -210...210)
        return randomX
    }
    
    func makeObstacle() {
        let randomX = randomPosX()
        let obstacle = SKSpriteNode(imageNamed: "huddle")
        obstacle.size = CGSize(width: frame.size.width * 0.2 , height: frame.size
            .height * 0.1)
        obstacle.position = CGPoint(x: randomX, y: -700)
        obstacle.name = "obstacle\(obstacleNumber)"
        obstacleNumber += 1
        
        self.addChild(obstacle)
        
        var heightScale = frame.size.height * 0.1
        
        obstacle.run(SKAction.moveBy(x: 0, y:heightScale, duration: 0.1))
    }
    
    
}
