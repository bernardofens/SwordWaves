//
//  MenuScene.swift
//  POC-2DGame
//
//  Created by Bernardo Garcia Fensterseifer on 11/03/26.
//


// MARK: - MenuScene
// Main menu with Play and Shop buttons.
import SpriteKit

class MenuScene: SKScene {

    private var totalCoins: Int {
        UserDefaults.standard.integer(forKey: "totalCoins")
    }

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.1, alpha: 1)
        setupBackground()
        setupTitle()
        setupCoinDisplay()
        setupButtons()
    }

    private func setupBackground() {
        let colors: [UIColor] = [
            UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.2),
            UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 0.15),
            UIColor(red: 0.6, green: 0.1, blue: 0.8, alpha: 0.15)
        ]
        let radii: [CGFloat] = [14, 22, 32]

        for i in 0..<14 {
            let idx = i % 3
            let circle = SKShapeNode(circleOfRadius: radii[idx])
            circle.fillColor = colors[idx]
            circle.strokeColor = .clear
            circle.position = CGPoint(
                x: CGFloat.random(in: -size.width/2 ... size.width/2),
                y: CGFloat.random(in: -size.height/2 ... size.height/2)
            )
            circle.zPosition = -1
            let dx = CGFloat.random(in: -40...40)
            let dy = CGFloat.random(in: -40...40)
            circle.run(.repeatForever(.sequence([
                .moveBy(x: dx, y: dy, duration: Double.random(in: 2...4)),
                .moveBy(x: -dx, y: -dy, duration: Double.random(in: 2...4))
            ])))
            addChild(circle)
        }
    }

    private func setupTitle() {
        // Title — left side of landscape screen
        let title = SKLabelNode(text: "SWORD WAVES")
        title.fontName = "AvenirNext-Heavy"
        title.fontSize = 36
        title.fontColor = .white
        title.position = CGPoint(x: -size.width * 0.22, y: 60)
        title.horizontalAlignmentMode = .center
        title.zPosition = 10
        addChild(title)

        let subtitle = SKLabelNode(text: "survive the endless onslaught")
        subtitle.fontName = "AvenirNext-Medium"
        subtitle.fontSize = 13
        subtitle.fontColor = UIColor(white: 0.6, alpha: 1)
        subtitle.position = CGPoint(x: -size.width * 0.22, y: 30)
        subtitle.horizontalAlignmentMode = .center
        subtitle.zPosition = 10
        addChild(subtitle)

        // Spinning player square preview
        let playerPreview = SKShapeNode(rectOf: CGSize(width: 36, height: 36), cornerRadius: 4)
        playerPreview.fillColor = .white
        playerPreview.strokeColor = .lightGray
        playerPreview.lineWidth = 1.5
        playerPreview.position = CGPoint(x: -size.width * 0.22, y: -20)
        playerPreview.zPosition = 10
        playerPreview.run(.repeatForever(.rotate(byAngle: .pi * 2, duration: 3)))
        addChild(playerPreview)
    }

    private func setupCoinDisplay() {
        let coinIcon = SKShapeNode(circleOfRadius: 9)
        coinIcon.fillColor = .yellow
        coinIcon.strokeColor = UIColor(red: 0.8, green: 0.6, blue: 0, alpha: 1)
        coinIcon.lineWidth = 1.5
        coinIcon.position = CGPoint(x: -size.width * 0.22 - 36, y: -60)
        coinIcon.zPosition = 10
        addChild(coinIcon)

        let coinLabel = SKLabelNode(text: "\(totalCoins) coins")
        coinLabel.fontName = "AvenirNext-Bold"
        coinLabel.fontSize = 16
        coinLabel.fontColor = .yellow
        coinLabel.position = CGPoint(x: -size.width * 0.22 - 18, y: -67)
        coinLabel.horizontalAlignmentMode = .left
        coinLabel.zPosition = 10
        addChild(coinLabel)
    }

    private func setupButtons() {
        // Buttons on the right side
        makeButton(
            text: "▶  PLAY",
            color: UIColor(red: 0.1, green: 0.55, blue: 0.1, alpha: 0.95),
            position: CGPoint(x: size.width * 0.2, y: 30),
            name: "playButton",
            width: 200
        )

        makeButton(
            text: "🛒  SHOP",
            color: UIColor(red: 0.15, green: 0.15, blue: 0.55, alpha: 0.95),
            position: CGPoint(x: size.width * 0.2, y: -50),
            name: "shopButton",
            width: 200
        )
    }

    private func makeButton(text: String, color: UIColor, position: CGPoint, name: String, width: CGFloat = 180) {
        let bg = SKShapeNode(rectOf: CGSize(width: width, height: 52), cornerRadius: 12)
        bg.fillColor = color
        bg.strokeColor = UIColor(white: 1, alpha: 0.6)
        bg.lineWidth = 1.5
        bg.position = position
        bg.zPosition = 10
        bg.name = name
        addChild(bg)

        let label = SKLabelNode(text: text)
        label.fontName = "AvenirNext-Heavy"
        label.fontSize = 20
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = 1
        label.name = name
        bg.addChild(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view else { return }
        let loc = touch.location(in: self)
        let hit = nodes(at: loc).compactMap { $0.name }

        if hit.contains("playButton") {
            let scene = GameScene(size: self.size)
            scene.scaleMode = self.scaleMode
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene, transition: .doorway(withDuration: 0.4))
        } else if hit.contains("shopButton") {
            let scene = ShopScene(size: self.size)
            scene.scaleMode = self.scaleMode
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene, transition: .push(with: .left, duration: 0.3))
        }
    }
}
