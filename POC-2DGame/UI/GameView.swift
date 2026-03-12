//
//  GameView.swift
//  POC-2DGame
//

import SwiftUI
import SpriteKit
import UIKit

struct GameView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> GameViewController {
        return GameViewController()
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {}
}

// MARK: - GameViewController
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Only set up the SKView once, after we have a real frame
        guard view.subviews.isEmpty else { return }

        let skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        skView.showsFPS       = true
        skView.showsNodeCount = true
        view.addSubview(skView)

        let scene = MenuScene(size: skView.bounds.size)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode   = .resizeFill
        skView.presentScene(scene)
    }

    // Lock to landscape
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }
    override var prefersStatusBarHidden: Bool { true }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }
}
