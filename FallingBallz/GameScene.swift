//
//  GameScene.swift
//  FallingBallz
//
//  Created by 조한동 on 2023/06/22.

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // 원이 떨어질 수 있는 세로 칸의 개수
    let verticalCellCount: Int = 6
    var valueCounter: Int = 0
    // 현재 화면에 존재하는 원의 배열
    var shapeNodes: [SKShapeNode] = []
    enum ShapeType {
        case circle
        case square
        case triangle
    }
    override func didMove(to view: SKView) {
//        self.isUserInteractionEnabled = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 아래에서 랜덤으로 원 생성
        createRandomShape()
        
        // 기존에 존재하는 도형들을 한 칸씩 위로 이동
        moveCirclesUp()
        
        //화면 터치할 때마다 값 증가
        valueCounter += 1
    }
    func createRandomShape() {
        let numberOfShapes = Int.random(in: 1...3) // 1개에서 3개의 원 생성
        
        var usedXPositions: Set<CGFloat> = [] // 사용된 x 좌표 저장
        var createdShapes: [SKShapeNode] = [] // 생성된 도형 저장
        
        for _ in 1...numberOfShapes {
            var randomX = CGFloat.random(in: shapeRadius() ..< (size.width - shapeRadius()))
            
            // 이미 사용된 x 좌표일 경우 다른 좌표 선택
//            while usedXPositions.contains(randomX) {
//                randomX = CGFloat.random(in: shapeRadius() ..< (size.width - shapeRadius()))
//            }
            while usedXPositions.contains(where: { $0 >= (randomX - paddingValue()) && $0 <= (randomX + paddingValue()) }) {
                randomX = CGFloat.random(in: shapeRadius() ..< (size.width - shapeRadius()))
            }

            
            let startY = -shapeRadius() // 시작 위치는 화면 밖으로 설정
            
            let shapeType = randomShapeType()
            let shapeNode: SKShapeNode
            switch shapeType {
            case .circle:
                shapeNode = SKShapeNode(circleOfRadius: shapeRadius())
            case .square:
                shapeNode = SKShapeNode(rectOf: CGSize(width: shapeRadius() * 1.8, height: shapeRadius() * 1.8))
            case .triangle:
                let trianglePath = createTrianglePath(size: CGSize(width: shapeRadius() * 2, height: shapeRadius() * 2))
                shapeNode = SKShapeNode(path: trianglePath)
            }

            shapeNode.fillColor = .red
            shapeNode.strokeColor = .clear
            shapeNode.position = CGPoint(x: randomX, y: startY)
            addChild(shapeNode)
            
            let valueLabel = createValueLabel()
            shapeNode.addChild(valueLabel)
            //zposition 주기 (안정성문제)
            
            
            shapeNode.physicsBody = SKPhysicsBody(polygonFrom: shapeNode.path!)
            shapeNode.physicsBody?.isDynamic = false
            shapeNode.physicsBody?.affectedByGravity = false
            
            
            // 사용된 x 좌표와 생성된 원들에 추가
//            usedXPositions.insert(randomX)
            usedXPositions.insert(shapeNode.position.x)
            createdShapes.append(shapeNode)
        }
        // 생성된 원들을 배열에 추가
        shapeNodes.append(contentsOf: createdShapes)
    } //createRandomShape
    
    
    func createTrianglePath(size: CGSize) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -size.width / 2, y: -size.height / 2))
        path.addLine(to: CGPoint(x: size.width / 2, y: -size.height / 2))
        path.addLine(to: CGPoint(x: 0, y: size.height / 2))
        path.close()
        return path.cgPath
    }
    func createValueLabel() -> SKLabelNode {
        let valueLabel = SKLabelNode(fontNamed: "Arial")
        valueLabel.fontSize = 25
        valueLabel.fontColor = .white
        valueLabel.text = "\(valueCounter)"
        valueLabel.position = CGPoint(x: 0, y: -10)
//        valueLabel.position = CGPoint(x: 0, y: randomShapeType() == .circle ? -20 : 0)
        return valueLabel
    }
    
    func randomShapeType() -> ShapeType {
        let randomValue = Int.random(in: 0...2)
        switch randomValue {
        case 0:
            return .circle
        case 1:
            return .square
        case 2:
            return .triangle
        default:
            return .circle
        }
    }
    func moveCirclesUp() {
        // 기존에 존재하는 도형들을 한 칸씩 위로 이동
        for shapeNode in shapeNodes {
            let newY = shapeNode.position.y + cellHeight()
            let moveAction = SKAction.move(to: CGPoint(x: shapeNode.position.x, y: newY), duration: 0.3)
            shapeNode.run(moveAction)
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([moveAction, removeAction])
            
            if newY >= (size.height - size.height / 6) {
                shapeNode.run(sequenceAction)
                
                if let index = shapeNodes.firstIndex(of: shapeNode) {
                    shapeNodes.remove(at: index)
                }
            } else {
                shapeNode.run(moveAction)
            }
        }
    }
    func shapeRadius() -> CGFloat {
        return size.width / 10 // 반지름 크기 조정
    }
    func paddingValue() -> CGFloat {
        return size.width / 5
    }
    func cellHeight() -> CGFloat {
        return size.height / CGFloat(verticalCellCount)
    }
}
