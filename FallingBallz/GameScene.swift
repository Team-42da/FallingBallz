import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var obstacleNumber : Int = 0
    var scoreLabel: SKLabelNode!
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    var ball: SKSpriteNode!
    var obstacle: SKSpriteNode!

    var touchStartPosition: CGPoint = .zero
    var gravityDirection: CGVector = CGVector(dx: 0, dy: -9.8)
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = gravityDirection
        physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0.5
        self.physicsBody = borderBody
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: -130, y: 550)
        
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // 터치된 노드를 찾습니다.
        let touchedNode = self.atPoint(touchLocation)
        
//        MARK:: didBegin에 공과 닿으면 사라지게 만들어서 일단 주석처리해둘게여
//        터치된 노드가 `obstacle`인지 확인하고, nodeCount를 줄입니다.
//        if let obstacleNode = touchedNode as? SKSpriteNode, obstacleNode.name?.hasPrefix("obstacle") == true {
//            decreaseNodeCount(obstacleNode)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let randomObsacleNumber = Int.random(in: 1...2)
        let positions = checkInterNode(numOfNodes: randomObsacleNumber)

        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        makeBall(destPosition: touchLocation)
        
        for xPos in positions {
            makeObstacle(xPos: xPos)
            
        }
        
        self.enumerateChildNodes(withName: "//obstacle*") { (node, stop) in
            node.run(SKAction.moveBy(x: 0, y: self.frame.size.height * 0.11, duration: 0.1))
            if node.position.y > -800 + self.frame.size.height * 0.11 * 8 {
                node.removeFromParent()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    //공과 블록이 부딪히면 블록의 count값 감소하도록 완성
    func didBegin(_ contact: SKPhysicsContact) {
        if let obstacle = contact.bodyA.node as? SKSpriteNode, let ball = contact.bodyB.node as? SKSpriteNode {
            decreaseNodeCount(obstacle)
        }
        
    }
    
    func checkInterNode(numOfNodes: Int) -> [CGFloat] {
        var positions: [CGFloat] = []
        let nodeInterSize = frame.size.width * 0.15
        
        for _ in 0..<numOfNodes {
            var isValid = false
            var randomX: CGFloat!
            
            // while !isValid
            repeat {
                randomX = CGFloat.random(in: -280...280)
                
                isValid = positions.allSatisfy { xPos in
                    let leftside = xPos-nodeInterSize > randomX+nodeInterSize
                    let rightside = xPos+nodeInterSize < randomX-nodeInterSize
                    return leftside || rightside
                }
            } while !isValid
            positions.append(randomX)

        }
        return positions
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
    
    func detectContact() {
        
        
        
    }
    
    // MARK: - 장애물생성
    func makeObstacle(xPos: CGFloat) -> Int {
        
        let randomShape = randomHuddle()
        let texture = SKTexture(imageNamed: "\(randomShape)")
        let obstacle = SKSpriteNode(imageNamed: "\(randomShape)")
        let padding: CGFloat = 50.0
        let paddedSize = CGSize(width: texture.size().width + padding, height: texture.size().height + padding)
        
        obstacle.size = CGSize(width: frame.size.width * 0.15 , height: frame.size
            .height * 0.08)
        
        obstacle.position = CGPoint(x: xPos, y: -600)
        obstacle.name = "obstacle\(obstacleNumber)"
        obstacleNumber += 1
        
        obstacle.physicsBody = SKPhysicsBody(texture: texture, size: paddedSize)
        obstacle.physicsBody!.friction = 0.0
        obstacle.physicsBody!.isDynamic = false
        obstacle.physicsBody!.allowsRotation = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.zPosition = 1
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.contactTestBitMask = ballCategory

        
        //count 추가
        let labelNode = addCount()
        guard let nodeCnt = Int(labelNode.text!) else { return 0 }
        
        obstacle.addChild(labelNode)
        self.addChild(obstacle)
        
        let heightScale = frame.size.height * 0.11
        
        obstacle.run(SKAction.moveBy(x: 0, y: heightScale, duration: 0.1))
        
        return nodeCnt
    }
    
    
//    func setupGravity(destPosition: CGPoint) {
//        gravityDirection = CGVector(dx: 0, dy: -9.8)
//
//        let gravityMagnitude: CGFloat = 9.8  // 중력의 크기
//
//        let center = CGPoint(x: 0, y: 600)  // 중심 좌표
//        let point = destPosition // 주어진 점
//
//        let dx = point.x - center.x
//        let dy = point.y - center.y
//
//        //let distance = hypot(dx, dy)
//        let angle = atan2(dy, dx)
//
//        let degrees = angle * 180 / .pi
//
//        //let gravityDirection = CGVector(dx: cos(dx) * gravityMagnitude, dy: -gravityMagnitude)
//        gravityDirection = CGVector(dx: cos(degrees) * gravityMagnitude, dy: -gravityMagnitude)
//        physicsWorld.gravity = gravityDirection
//
//    }

    
    func makeBall(destPosition: CGPoint) {
        physicsWorld.contactDelegate = self

        
        //let ball = SKSpriteNode(color: SKColor.white, size: CGSize(width: 20, height:20))
        let ball = SKSpriteNode(imageNamed: "Circle")
        ball.size = CGSize(width: 30, height: 30)
        
        ball.position = CGPoint(x:0, y: 600)
        let ballPhysics = SKPhysicsBody(circleOfRadius: 10)
        
        let x = destPosition.x - 0 // 공의 시작위치의 x값
        let y = destPosition.y - 600 // 공 시작위치의 y값
        let magnitude = sqrt(x * x + y * y)
        let dx = x / magnitude
        let dy = y / magnitude
        
        let forceMagnitude: CGFloat = 150.0  // 공이 나가는 힘
        let force = CGVector(dx: dx * forceMagnitude, dy: dy * forceMagnitude)
        
        ball.physicsBody = ballPhysics
        ballPhysics.friction = 0.0
        ballPhysics.isDynamic = true
        ballPhysics.affectedByGravity = true
        ballPhysics.categoryBitMask = ballCategory
        ballPhysics.contactTestBitMask = obstacleCategory
        ballPhysics.isDynamic = true // 물리적 시뮬레이션에 응답
        ballPhysics.restitution = 0.8 // 튕겨나가는 정도 설정

        self.addChild(ball)
        

        ballPhysics.applyForce(force)

        
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
