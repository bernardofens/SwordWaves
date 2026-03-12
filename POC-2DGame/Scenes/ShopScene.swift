//
//  ShopScene.swift
//  POC-2DGame
//
//  Created by Bernardo Garcia Fensterseifer on 11/03/26.
//


// MARK: - ShopScene
// Placeholder shop. Items will be filled in when ready.
// Coins are read from UserDefaults and shown to the player.

import SpriteKit

class ShopScene: SKScene {

    private var totalCoins: Int {
        UserDefaults.standard.integer(forKey: "totalCoins")
    }

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.1, alpha: 1)
        setupTitle()
        setupCoinDisplay()
        setupComingSoon()
        setupBackButton()
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "SHOP")
        title.fontName = "AvenirNext-Heavy"
        title.fontSize = 32
        title.fontColor = .yellow
        title.position = CGPoint(x: -size.width * 0.25, y: size.height * 0.3)
        title.horizontalAlignmentMode = .center
        title.zPosition = 10
        addChild(title)
    }

    private func setupCoinDisplay() {
        let container = SKShapeNode(rectOf: CGSize(width: 150, height: 40), cornerRadius: 10)
        container.fillColor = UIColor(white: 0.15, alpha: 0.9)
        container.strokeColor = .yellow
        container.lineWidth = 1.5
        container.position = CGPoint(x: -size.width * 0.25, y: size.height * 0.1)
        container.zPosition = 10
        addChild(container)

        let coinIcon = SKShapeNode(circleOfRadius: 9)
        coinIcon.fillColor = .yellow
        coinIcon.strokeColor = UIColor(red: 0.8, green: 0.6, blue: 0, alpha: 1)
        coinIcon.lineWidth = 1.5
        coinIcon.position = CGPoint(x: -45, y: 0)
        coinIcon.zPosition = 1
        container.addChild(coinIcon)

        let label = SKLabelNode(text: "\(totalCoins) coins")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 16
        label.fontColor = .yellow
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: -28, y: 0)
        label.zPosition = 1
        container.addChild(label)
    }

    private func setupComingSoon() {
        for i in 0..<3 {
            let slot = SKShapeNode(rectOf: CGSize(width: 240, height: 58), cornerRadius: 10)
            slot.fillColor = UIColor(white: 0.12, alpha: 0.8)
            slot.strokeColor = UIColor(white: 0.3, alpha: 1)
            slot.lineWidth = 1
            slot.position = CGPoint(x: size.width * 0.18, y: CGFloat(1 - i) * 74)
            slot.zPosition = 10
            addChild(slot)

            let lock = SKLabelNode(text: "🔒")
            lock.fontSize = 20
            lock.position = CGPoint(x: -85, y: -7)
            lock.zPosition = 1
            slot.addChild(lock)

            let coming = SKLabelNode(text: "Coming soon...")
            coming.fontName = "AvenirNext-Medium"
            coming.fontSize = 14
            coming.fontColor = UIColor(white: 0.5, alpha: 1)
            coming.verticalAlignmentMode = .center
            coming.position = CGPoint(x: 10, y: 0)
            coming.zPosition = 1
            slot.addChild(coming)
        }
    }

    private func setupBackButton() {
        let bg = SKShapeNode(rectOf: CGSize(width: 120, height: 40), cornerRadius: 10)
        bg.fillColor = UIColor(white: 0.2, alpha: 0.9)
        bg.strokeColor = .white
        bg.lineWidth = 1.5
        bg.position = CGPoint(x: -size.width * 0.25, y: -size.height * 0.32)
        bg.zPosition = 10
        bg.name = "backButton"
        addChild(bg)

        let label = SKLabelNode(text: "← BACK")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 15
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = "backButton"
        label.zPosition = 1
        bg.addChild(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view else { return }
        let loc = touch.location(in: self)
        if nodes(at: loc).contains(where: { $0.name == "backButton" }) {
            let scene = MenuScene(size: size)
            scene.scaleMode = scaleMode
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene, transition: .push(with: .right, duration: 0.3))
        }
    }
}
