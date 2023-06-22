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
    
    // 누르면 볼이 향할 방향 나타내기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let randomObsacleNumber = Int.random(in: 1...3)
        if randomObsacleNumber == 1 {
            makeObstacle()
        } else if randomObsacleNumber == 2{
            makeObstacle()
            makeObstacle()
        } else {
            makeObstacle()
            makeObstacle()
            makeObstacle()
        }

        
        self.enumerateChildNodes(withName: "//obstacle*") { (node, stop) in
            node.run(SKAction.moveBy(x: 0, y: self.frame.size.height * 0.15, duration: 0.1))
            if node.position.y > -800 + self.frame.size.height * 0.15 * 5 {
                node.removeFromParent()
            }
        }
    }
    
    func randomPosX() -> Int {
        let randomX = Int.random(in: -210...210)
        return randomX
    }
    
    func randomHuddle() -> String {
        let randomShape = Int.random(in: 0...2)
        let shapeName: String
        
        switch randomShape {
        case 0:
            shapeName = "Triangle"
        case 1:
            shapeName = "Circle"
        case 2:
            shapeName = "Rectangle"
        default:
            shapeName = "Circle"
        }
        
        return shapeName
    }
    
    func makeObstacle() {
        let randomX = randomPosX()
        let randomShape = randomHuddle()
        let obstacle = SKSpriteNode(imageNamed: "huddle\(randomShape)")
        obstacle.size = CGSize(width: frame.size.width * 0.2 , height: frame.size
            .height * 0.1)
        obstacle.position = CGPoint(x: randomX, y: -800)
        obstacle.name = "obstacle\(obstacleNumber)"
        obstacleNumber += 1
        
        self.addChild(obstacle)
        
        let heightScale = frame.size.height * 0.1
        
        obstacle.run(SKAction.moveBy(x: 0, y: heightScale, duration: 0.1))
    }
    
    
}
