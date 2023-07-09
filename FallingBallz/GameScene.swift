//
//  GameScene.swift
//  FallingBallz
//
//  Created by 조한동 on 2023/06/22.

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let ball = SKSpriteNode(imageNamed: "ball")
    let square = SKSpriteNode(imageNamed: "square")
    let circle = SKSpriteNode(imageNamed: "circle")
    let aimLine = SKShapeNode()
    var isAiming = false
    var isBallMoving = false
    var touchStartPoint: CGPoint = .zero
    var levelValue: Int = 15
    var levelLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let screenSize = self.size
        let leftWallNode = SKShapeNode(rectOf: CGSize(width: 3, height: self.size.height))
        let rightWallNode = SKShapeNode(rectOf: CGSize(width: 3, height: self.size.height))
        
        leftWallNode.position = CGPoint(x: 0, y: size.height / 2)
        leftWallNode.fillColor = .red
        addChild(leftWallNode)
        leftWallNode.physicsBody = SKPhysicsBody(rectangleOf: leftWallNode.frame.size)
        leftWallNode.physicsBody?.affectedByGravity = false
        leftWallNode.physicsBody?.collisionBitMask = 0 // 이거 쓰면 충돌해도 사라지지 않음.
        
        rightWallNode.position = CGPoint(x: size.width, y: size.height / 2)
        rightWallNode.fillColor = .red
        addChild(rightWallNode)
        rightWallNode.physicsBody = SKPhysicsBody(rectangleOf: rightWallNode.frame.size)
        rightWallNode.physicsBody?.affectedByGravity = false
        rightWallNode.physicsBody?.collisionBitMask = 0 // 이거 쓰면 충돌해도 사라지지 않음.
        

        
        ball.position = CGPoint(x: screenSize.width / 2, y: screenSize.height - 100)
        addChild(ball)
        
        square.position = CGPoint(x: screenSize.width / 3, y: screenSize.height / 2)
        addChild(square)
        circle.position = CGPoint(x: screenSize.width / 1.5, y: screenSize.height / 3)
        addChild(circle)
        
        // ball과 square의 충돌을 감지하기 위해 물리 연산 대리자로 self를 설정
        physicsWorld.contactDelegate = self
        levelLabel = SKLabelNode(text: "\(levelValue)")
        levelLabel.fontSize = 30
        levelLabel.fontColor = .red
        square.addChild(levelLabel)
        
        square.physicsBody = SKPhysicsBody(rectangleOf: square.size)
        square.physicsBody?.categoryBitMask = 1 // 충돌 카테고리 설정
        square.physicsBody?.contactTestBitMask = 2 // 충돌 검사 카테고리 설정
        square.physicsBody?.collisionBitMask = 0 // 충돌하지 않음
        square.physicsBody?.affectedByGravity = false
        
        circle.physicsBody = SKPhysicsBody(rectangleOf: circle.size)
        circle.physicsBody?.collisionBitMask = 0 // 충돌하지 않음
        circle.physicsBody?.affectedByGravity = false
        
        aimLine.strokeColor = .white
        aimLine.position = ball.position
        addChild(aimLine)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            touchStartPoint = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isBallMoving, let touch = touches.first {
            let touchEndPoint = touch.location(in: self)
            shootBall(from: touchStartPoint, to: touchEndPoint)
        }
    }

    func shootBall(from startPoint: CGPoint, to endPoint: CGPoint) {
        let direction = endPoint - startPoint
        let speed: CGFloat = 700.0
        
        // ball에 물리적 특성 추가 (중력 적용)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 0.6 //튕김정도 조절

        // 방향 벡터의 크기를 조절하여 속도 조절
        let magnitude = sqrt(direction.x * direction.x + direction.y * direction.y)
        let normalizedDirection = CGPoint(x: direction.x / magnitude, y: direction.y / magnitude)
        let velocity = CGVector(dx: normalizedDirection.x * speed, dy: normalizedDirection.y * speed)
        if isBallMoving == false {
            // ball에 초기 속도 설정하여 발사
            ball.physicsBody?.velocity = velocity
            isBallMoving = true
        }
    }
    override func update(_ currentTime: TimeInterval) {
        guard let physicsBody = ball.physicsBody else {
            return
        }
        
        if ball.position.y < -100 {
            // 화면 아래로 사라지면 ball을 리셋
            physicsBody.velocity = .zero
            ball.position = CGPoint(x: size.width / 2, y: size.height - 100)
            isBallMoving = false
            ball.physicsBody?.affectedByGravity = false
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        // ball과 square 충돌 시 호출되는 메서드
        if contact.bodyA.node == ball || contact.bodyB.node == ball {
            levelValue -= 1 // Label 값을 1 감소
            levelLabel.text = "\(levelValue)"
            
            if levelValue == 0 {
                square.removeFromParent() // square 스프라이트 제거
            }
        }
    }
}

extension CGPoint {
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}






//class GameScene: SKScene, SKPhysicsContactDelegate {
//
//        let spriteTypes = ["circle", "square", "triangle"] // Sprite 종류들
//
//        override func didMove(to view: SKView) {
//            // Sprite 생성 함수 호출
//            createSprites()
//        }
//
//        func createSprites() {
//            let minX = size.width * 0.1 // 생성할 Sprite의 최소 x 좌표
//            let maxX = size.width * 0.9 // 생성할 Sprite의 최대 x 좌표
//
//            let spriteCount = Int.random(in: 1...3) // 생성할 Sprite 개수
//
//            for _ in 1...spriteCount {
//                let randomX = CGFloat.random(in: minX...maxX)
//                let spriteType = spriteTypes.randomElement()!
//
//                let sprite = createSprite(type: spriteType)
//                sprite.position = CGPoint(x: randomX, y: 0)
//
//                addChild(sprite)
//            }
//        }
//
//        func createSprite(type: String) -> SKSpriteNode {
//            let sprite = SKSpriteNode(imageNamed: type)
//
//            return sprite
//        }
//
//
//    struct Queue<T> {
//        private var queue: [T] = []
//
//        public var count: Int {
//            return queue.count
//        }
//
//        public var isEmpty: Bool {
//            return queue.isEmpty
//        }
//
//        public mutating func enqueue(_ element: T) {
//            queue.append(element)
//        }
//
//        public mutating func dequeue() -> T? {
//            return isEmpty ? nil : queue.removeFirst()
//        }
//    }
//
//}
