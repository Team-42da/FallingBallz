//
//  GameScene.swift
//  FallingBallz
//
//  Created by Greed on 2023/06/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var obstacleNumber : Int = 0
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: -130, y: 550)
        addChild(scoreLabel)
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
            node.run(SKAction.moveBy(x: 0, y: self.frame.size.height * 0.11, duration: 0.1))
            if node.position.y > -800 + self.frame.size.height * 0.11 * 8 {
                node.removeFromParent()
                self.score += 1
            }
        }
    }
    
    func randomPosX() -> Int {
        let randomX = Int.random(in: -300...300)
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
        obstacle.size = CGSize(width: frame.size.width * 0.15 , height: frame.size
            .height * 0.08)
        obstacle.position = CGPoint(x: randomX, y: -600)
        obstacle.name = "obstacle\(obstacleNumber)"
        obstacleNumber += 1
        
        let obstaclePadding = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width + 30 , height: obstacle.size.height + 10 ))
        obstacle.physicsBody = obstaclePadding
        obstacle.physicsBody!.friction = 0.0
        obstacle.physicsBody!.isDynamic = true
        obstacle.physicsBody!.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.zPosition = 1
        
        let labelNode = addCount()
        obstacle.addChild(labelNode)
        self.addChild(obstacle)
        
        let heightScale = frame.size.height * 0.11
        
        obstacle.run(SKAction.moveBy(x: 0, y: heightScale, duration: 0.1))
    }
    
    func addCount() -> SKLabelNode {
        let nodeCount: Int
        
        switch score {
        case 0...10:
            nodeCount = Int.random(in: 1...3)
        case 11...20:
            nodeCount = Int.random(in: 4...10)
        case 21...40:
            nodeCount = Int.random(in: 11...20)
        case 41...60:
            nodeCount = Int.random(in: 21...30)
        default:
            nodeCount = Int.random(in: 1...100)
        }
        let labelNode = SKLabelNode(text: "\(nodeCount)")
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 40
        labelNode.fontName = "SFUI-Regular"
        labelNode.position = CGPoint(x: -2, y: -18)
        labelNode.zPosition = 2
        
        return labelNode
    }
    
}
