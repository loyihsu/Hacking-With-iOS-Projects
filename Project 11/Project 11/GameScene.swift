//
//  GameScene.swift
//  Project 11
//
//  Created by Yu-Sung Loyi Hsu on 2022/2/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    enum BallType: String, CaseIterable {
        case ballBlue, ballCyan, ballGreen, ballGrey, ballPurple, ballRed, ballYellow
    }

    private func getRandomBall() -> String {
        return BallType.allCases.randomElement()!.rawValue
    }

    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!

    var ballCount = 5

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var editingMode: Bool = false {
        didSet {
            editLabel.text = editingMode
            ? "Done"
            : "Edit"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128),
                                      height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1),
                                                          green: CGFloat.random(in: 0...1),
                                                          blue: CGFloat.random(in: 0...1),
                                                          alpha: 1),
                                           size: size)

                    box.name = "box"

                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location

                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false

                    addChild(box)
                } else {
                    guard location.y > size.height / 2 else {
                        return
                    }
                    guard ballCount >= 0 else {
                        return
                    }

                    let ball = SKSpriteNode(imageNamed: getRandomBall())

                    ball.name = "ball"

                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)

                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask

                    ball.physicsBody?.restitution = 0.4
                    ball.position = location
                    addChild(ball)

                    ballCount -= 1
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    private func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }

    private func makeSlot(at position: CGPoint, isGood: Bool) {
        let slotBase = SKSpriteNode(
            imageNamed: isGood
            ? "slotBaseGood"
            : "slotBaseBad"
        )
        let slotGlow = SKSpriteNode(
            imageNamed: isGood
            ? "slotGlowGood"
            : "slotGlowBad"
        )

        slotBase.name = isGood ? "good" : "bad"

        slotBase.position = position
        slotGlow.position = position

        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false

        addChild(slotBase)
        addChild(slotGlow)

        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }

    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballCount += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "box" {
            destroy(box: object)
        }
    }

    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
    }

    func destroy(box: SKNode) {
        box.removeFromParent()
    }
}
