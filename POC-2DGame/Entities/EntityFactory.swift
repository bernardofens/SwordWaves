// MARK: - EntityFactory
// Builds fully-composed entities with their SKSpriteNode visuals.
//
// ╔══════════════════════════════════════════════════════════╗
// ║              ASSET NAMES — EDIT HERE                     ║
// ╠══════════════════════════════════════════════════════════╣
// ║  player_sprite      → player character (48×48 px)        ║
// ║  enemy_weak         → small enemy     (28×28 px)         ║
// ║  enemy_normal       → medium enemy    (44×44 px)         ║
// ║  enemy_strong       → large enemy     (64×64 px)         ║
// ║  coin_sprite        → collectible coin (20×20 px)        ║
// ╚══════════════════════════════════════════════════════════╝

import SpriteKit
import Foundation

// MARK: - Asset name constants (change here to rename assets)
enum AssetName {
    static let player      = "player_sprite"   // ← your player image name in Assets.xcassets
    static let enemyWeak   = "enemy_weak"      // ← small enemy image
    static let enemyNormal = "enemy_normal"    // ← medium enemy image
    static let enemyStrong = "enemy_strong"    // ← large enemy image
    static let coin        = "coin_sprite"     // ← coin image
}

class EntityFactory {

    // MARK: Player
    static func makePlayer(at position: CGPoint, scene: SKScene) -> Entity {
        let entity = Entity()

        let node = SKSpriteNode(imageNamed: AssetName.player)
        node.size     = CGSize(width: 68, height: 68)   // fixed size — adjust if needed
        node.position = position
        node.zPosition = 10
        scene.addChild(node)

        entity.add(TransformComponent(node: node))
        entity.add(HealthComponent(max: 100))
        entity.add(MovementComponent(speed: 220))
        entity.add(PlayerComponent())
        entity.add(InputComponent())
        entity.add(AttackComponent(damage: 25, range: 70, cooldown: 0.4))

        return entity
    }

    // MARK: Enemy
    static func makeEnemy(type: EnemyComponent.EnemyType, at position: CGPoint, scene: SKScene) -> Entity {
        let entity = Entity()

        let imageName: String
        let spriteSize: CGSize
        switch type {
        case .weak:
            imageName  = AssetName.enemyWeak
            spriteSize = CGSize(width: 48, height: 48)   // fixed size for weak enemy
        case .normal:
            imageName  = AssetName.enemyNormal
            spriteSize = CGSize(width: 64, height: 64)   // fixed size for normal enemy
        case .strong:
            imageName  = AssetName.enemyStrong
            spriteSize = CGSize(width: 84, height: 84)   // fixed size for strong enemy
        }

        let node = SKSpriteNode(imageNamed: imageName)
        node.size      = spriteSize
        node.position  = position
        node.zPosition = 8
        scene.addChild(node)

        // Health bar background
        let barWidth: CGFloat  = spriteSize.width * 1.2
        let barHeight: CGFloat = 5
        let barBg = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight), cornerRadius: 2)
        barBg.fillColor   = UIColor(white: 0.2, alpha: 0.85)
        barBg.strokeColor = .clear
        barBg.position    = CGPoint(x: 0, y: spriteSize.height / 2 + 8)
        barBg.zPosition   = 1
        node.addChild(barBg)

        // Health bar fill
        let barFill = SKShapeNode(rectOf: CGSize(width: barWidth - 2, height: barHeight - 2), cornerRadius: 1.5)
        barFill.fillColor   = .green
        barFill.strokeColor = .clear
        barFill.zPosition   = 1
        barBg.addChild(barFill)

        let health = HealthComponent(max: type.maxHealth)
        health.healthBarBackground = barBg
        health.healthBarFill       = barFill

        entity.add(TransformComponent(node: node))
        entity.add(health)
        entity.add(MovementComponent(speed: type.speed))
        entity.add(EnemyComponent(type: type))

        return entity
    }

    // MARK: Coin
    static func makeCoin(at position: CGPoint, scene: SKScene) -> Entity {
        let entity = Entity()

        let node = SKSpriteNode(imageNamed: AssetName.coin)
        node.size      = CGSize(width: 40, height: 40)  // fixed coin size
        node.position  = position
        node.zPosition = 5
        node.run(.repeatForever(.sequence([
            .scale(to: 1.18, duration: 0.55),
            .scale(to: 1.0,  duration: 0.55)
        ])))
        scene.addChild(node)

        entity.add(TransformComponent(node: node))
        entity.add(CoinComponent())

        return entity
    }
}
