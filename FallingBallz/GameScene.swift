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
    
    // 누르면 볼이 향할 방향 나타내기 해야함
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //클릭하면 노드카운트 줄이기
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // 터치된 노드를 찾습니다.
        let touchedNode = self.atPoint(touchLocation)
        
        // 터치된 노드가 `obstacle`인지 확인하고, nodeCount를 줄입니다.
        if let obstacleNode = touchedNode as? SKSpriteNode, obstacleNode.name?.hasPrefix("obstacle") == true {
            decreaseNodeCount(obstacleNode)
        }
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
            }
            
        }
    }
    
    func decreaseNodeCount(_ obstacleNode: SKSpriteNode) {
        // obstacleNode에서 countLabel을 찾습니다.
        if let countNode = obstacleNode.childNode(withName: "countLabel") as? SKLabelNode {
            // 현재 nodeCount를 가져옵니다.
            if let countText = countNode.text, let count = Int(countText) {
                // nodeCount를 1씩 감소시키고, 0보다 작으면 노드를 제거합니다.
                let newCount = count - 1
                if newCount > 0 {
                    countNode.text = "\(newCount)"
                } else {
                    obstacleNode.removeFromParent()
                    self.score += 1
                }
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
    
    // MARK: - 장애물생성
    func makeObstacle() {
        //랜덤 모양, 위치 생성
        let randomX = randomPosX()
        let randomShape = randomHuddle()
        let obstacle = SKSpriteNode(imageNamed: "huddle\(randomShape)")
        obstacle.size = CGSize(width: frame.size.width * 0.15 , height: frame.size
            .height * 0.08)
        
        obstacle.position = CGPoint(x: randomX, y: -600)
        obstacle.name = "obstacle\(obstacleNumber)"
        obstacleNumber += 1
        
        //physics
        let obstaclePadding = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width + 50 , height: obstacle.size.height + 10 ))
        obstacle.physicsBody = obstaclePadding
        obstacle.physicsBody!.friction = 0.0
        obstacle.physicsBody!.isDynamic = true
        obstacle.physicsBody!.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.zPosition = 1
        
        //count 추가
        let labelNode = addCount()
        obstacle.addChild(labelNode)
        self.addChild(obstacle)
        
        let heightScale = frame.size.height * 0.11
        
        obstacle.run(SKAction.moveBy(x: 0, y: heightScale, duration: 0.1))
    }
    
    func addCount() -> SKLabelNode {
        let nodeCount: Int
        
        switch score {
        case 0...5:
            nodeCount = Int.random(in: 1...2)
        case 6...10:
            nodeCount = Int.random(in: 2...4)
        case 11...20:
            nodeCount = Int.random(in: 4...6)
        case 21...40:
            nodeCount = Int.random(in: 7...10)
        default:
            nodeCount = Int.random(in: score/5 - 2 ... score/5 + 3)
        }
        let labelNode = SKLabelNode(text: "\(nodeCount)")
        labelNode.name = "countLabel"
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 40
        labelNode.fontName = "SFUI-Regular"
        labelNode.position = CGPoint(x: -2, y: -18)
        labelNode.zPosition = 2
        
        return labelNode
    }
    
}
