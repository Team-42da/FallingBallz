//
//  GameScene.swift
//  FallingBallz
//
//  Created by Greed on 2023/06/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var arr : [String] = ["circle","triangle","rectangle"]
    private var obstacle : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
    }
    
    func moveObjectUp() {
        let moveAction = SKAction.moveBy(x: 0, y: 100, duration: 0.5) // Adjust the distance and duration as needed
        obstacle.run(moveAction)
    }
    
    func randObstacleShape () {
        
        
    }// 장애물 모양 랜덤으로 뽑아내는 함수
    
    func addObstacle (_ positionX : Int) {
        
        obstacle  = SKSpriteNode(imageNamed: "circle")
        obstacle?.position = CGPoint(x: positionX, y: -675)
        
    }// 장애물 생성하는 함수
    
    func randPositionX() {
        
    }// x값 랜덤으로 주는 함수 (패딩값도 고려하기)
    
    func randObstacleNum() {
        
    }// 장애물 개수 랜덤으로 생성
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }//터치가 되었을때
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }//터치가 끝났을때
    
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
