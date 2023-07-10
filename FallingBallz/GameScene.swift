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
    
    let ballCategory: UInt32 = 0x1 << 0 // 볼의 카테고리 비트마스크
    let obstacleCategory: UInt32 = 0x1 << 1
    let ballRadius: CGFloat = 20.0 // 볼의 반지름 값
    
    var touchStartPosition: CGPoint = .zero
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var myQueue = Queue<[Int]>()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // 왼벽 오른벽 생성
        let leftWall = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX + 80, y: frame.minY), to: CGPoint(x: frame.minX + 80, y: frame.maxY))
        leftWall.physicsBody?.friction = 0
        self.addChild(leftWall)
        
        let rightWall = SKNode()
        
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.maxX - 80, y: frame.minY), to: CGPoint(x: frame.maxX - 80, y: frame.maxY))
        rightWall.physicsBody?.friction = 0
        self.addChild(rightWall)
        
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: -130, y: 550)
        addChild(scoreLabel)
    }
    
    // 충돌을 처리
    func didBegin(_ contact: SKPhysicsContact) {
        if let obstacle = contact.bodyA.node as? SKSpriteNode, let _ = contact.bodyB.node as? SKSpriteNode {
            print("aaa")
            decreaseNodeCount(obstacle)
        }
    }
    
    // 누르면 볼이 향할 방향 나타내기 해야함
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //        //클릭하면 노드카운트 줄이기
        //        guard let touch = touches.first else { return }
        //        let touchLocation = touch.location(in: self)
        //
        //        // 터치된 노드를 찾습니다.
        //        let touchedNode = self.atPoint(touchLocation)
        //
        //        // 터치된 노드가 `obstacle`인지 확인하고, nodeCount를 줄입니다.
        //                if let obstacleNode = touchedNode as? SKSpriteNode, obstacleNode.name?.hasPrefix("obstacle") == true {
        //                    decreaseNodeCount(obstacleNode)
        //                }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        makeBall(touchLocation)
        
        arrangeObstacle()
        
        self.enumerateChildNodes(withName: "//obstacle*") { (node, stop) in
            node.run(SKAction.moveBy(x: 0, y: self.frame.size.height * 0.11, duration: 0.1))
            if node.position.y > -700 + self.frame.size.height * 0.11 * 6 {
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
    
    // MARK: - ball영역
    func makeBall(_ destPosition: CGPoint) {
        physicsWorld.contactDelegate = self
        
        let texture = SKTexture(imageNamed: "ball")
        let ball = SKSpriteNode(imageNamed: "ball")
        
        ball.position = CGPoint(x: 0, y: frame.size.height * 0.4)
        
        let x = destPosition.x - 0 // 공의 시작위치의 x값
        let y = destPosition.y - frame.size.height * 0.4 // 공 시작위치의 y값
        let magnitude = sqrt(x * x + y * y)
        let dx = x / magnitude
        let dy = y / magnitude
        
        let forceMagnitude: CGFloat = 500.0  // 공이 나가는 힘
        let force = CGVector(dx: dx * forceMagnitude, dy: dy * forceMagnitude)
        
        let ballPhysics = SKPhysicsBody(texture: texture, size: texture.size())
        ball.physicsBody = ballPhysics
        ball.physicsBody!.friction = 0
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.allowsRotation = true
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 0.8
//      ball.physicsBody?.linearDamping = 0.01 // 예시로 값을 조정
        
        ballPhysics.categoryBitMask = ballCategory
        ballPhysics.contactTestBitMask = obstacleCategory
        
        self.addChild(ball)
        
        ballPhysics.applyForce(force)
    }
    
    func randomPosX() -> [CGFloat] {
        var randomX: [CGFloat] = []
        var randomX1: CGFloat = 0
        var randomX2: CGFloat = 0
        var randomX3: CGFloat = 0
        
        repeat {
            randomX1 = CGFloat.random(in: -frame.width/2 + frame.size.width * 0.2...frame.width/2 - frame.size.width * 0.2)
            randomX2 = CGFloat.random(in: -frame.width/2 + frame.size.width * 0.2...frame.width/2 - frame.size.width * 0.2)
            randomX3 = CGFloat.random(in: -frame.width/2 + frame.size.width * 0.2...frame.width/2 - frame.size.width * 0.2)
        } while abs(randomX1 - randomX2) < frame.size.width * 0.2 || abs(randomX1 - randomX3) < frame.size.width * 0.2 || abs(randomX2 - randomX3) < frame.size.width * 0.2
        
        randomX.append(randomX1)
        randomX.append(randomX2)
        randomX.append(randomX3)
        return randomX
    }
    
    func randomHuddle() -> String {
        let randomShape = Int.random(in: 0...9)
        let shapeName: String
        
        switch randomShape {
        case 0...5:
            shapeName = "Circle"
        case 6...7:
            shapeName = "Triangle"
        case 8...9:
            shapeName = "Rectangle"
        default:
            shapeName = "Circle"
        }
        return shapeName
    }
    
    // MARK: - 장애물생성
    // return을 count값으로 String으로 해서 이를 arrange에서 받아서 거기서 queue에 추가
    func makeObstacle(_ positionX: CGFloat) -> Int {
        physicsWorld.contactDelegate = self
        //랜덤 모양, 위치 생성
        let randomShape = randomHuddle()
        let texture = SKTexture(imageNamed: "obstacle\(randomShape)")
        let obstacle = SKSpriteNode(imageNamed: "obstacle\(randomShape)")
        let padding: CGFloat = 35
        let paddedSize = CGSize(width: texture.size().width + padding, height: texture.size().height + padding)
        obstacle.size = CGSize(width: frame.size.width * 0.15, height: frame.size
            .height * 0.08)
        
        obstacle.position = CGPoint(x: positionX, y: -700)
        obstacle.name = "obstacle\(obstacleNumber)"
        obstacleNumber += 1
        
        //physics
        obstacle.physicsBody = SKPhysicsBody(texture: texture, size: paddedSize)
        obstacle.physicsBody?.friction = 0.0
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.contactTestBitMask = obstacleCategory
        obstacle.physicsBody?.categoryBitMask = ballCategory
        obstacle.zPosition = 1
        
        //count 추가
        let labelNode = addCount()
        guard let nodeCnt = Int(labelNode.text!) else { return 0 }
        
        obstacle.addChild(labelNode)
        self.addChild(obstacle)
        
        let heightScale = frame.size.height * 0.11
        
        obstacle.run(SKAction.moveBy(x: 0, y: heightScale, duration: 0.1))
        
        return nodeCnt
    }
    
    func arrangeObstacle() {
        let randomObsacleNumber = Int.random(in: 1...3)
        let randomX = randomPosX()
        let randomNumber = Int.random(in: 0...2)
        var tempArr: [Int] = []
        
        if randomObsacleNumber == 1 {
            let obstacle = makeObstacle(randomX[randomNumber])
            //            tempArr.append(Int(obstacle)!)
        } else if randomObsacleNumber == 2{
            let obstacle = makeObstacle(randomX[0])
            let obstacle2 = makeObstacle(randomX[1])
            //            tempArr.append(Int(obstacle)!)
            //            tempArr.append(Int(obstacle2)!)
        } else {
            let obstacle = makeObstacle(randomX[0])
            let obstacle2 = makeObstacle(randomX[1])
            let obstacle3 = makeObstacle(randomX[2])
            //            tempArr.append(Int(obstacle)!)
            //            tempArr.append(Int(obstacle2)!)
            //            tempArr.append(Int(obstacle3)!)
        }
        
        //        myQueue.enqueue(tempArr)
        //        print("myQueue : \(myQueue)")
    }
    
    func addCount() -> SKLabelNode {
        let nodeCount: Int
        
        switch score {
        case 0...5:
            nodeCount = 1
        case 6...10:
            nodeCount = Int.random(in: 2...4)
        case 11...20:
            nodeCount = Int.random(in: 4...6)
        case 21...40:
            nodeCount = Int.random(in: 7...10)
        default:
            nodeCount = Int.random(in: score/5 - 1 ... score/5 + 4)
        }
        let labelNode = SKLabelNode(text: "\(nodeCount)")
        labelNode.name = "countLabel"
        labelNode.fontColor = UIColor.black
        labelNode.fontSize = 40
        //        labelNode.fontName = "SFUI-Regular"
        labelNode.position = CGPoint(x: -2, y: -18)
        labelNode.zPosition = 2
        
        return labelNode
    }
    
    struct Queue<T> {
        private var queue: [T] = []
        
        public var count: Int {
            return queue.count
        }
        
        public var isEmpty: Bool {
            return queue.isEmpty
        }
        
        public mutating func enqueue(_ element: T) {
            queue.append(element)
        }
        
        public mutating func dequeue() -> T? {
            return isEmpty ? nil : queue.removeFirst()
        }
    }
    
}
