//
//  PlayerSystem.swift
//  POC-2DGame
//
//  Created by Bernardo Garcia Fensterseifer on 12/03/26.
//

import SpriteKit
import CoreMotion
import Foundation

class PlayerSystem {
    func update(
        playerEntity: Entity,
        motionDirection: CGVector,
        deltaTime: TimeInterval,
        currentTime: TimeInterval
    ) {
        guard
            let input    = playerEntity.get(InputComponent.self),
            let movement = playerEntity.get(MovementComponent.self),
            let attack   = playerEntity.get(AttackComponent.self),
            let player   = playerEntity.get(PlayerComponent.self)
        else { return }

        // Apply motion-based direction
        movement.velocity = CGVector(
            dx: motionDirection.dx * movement.speed,
            dy: motionDirection.dy * movement.speed
        )

        // Clamp to world bounds
        let worldHalf: CGFloat = 1180
        if let node = playerEntity.get(TransformComponent.self)?.node {
            node.position.x = Swift.max(-worldHalf, Swift.min(worldHalf, node.position.x))
            node.position.y = Swift.max(-worldHalf, Swift.min(worldHalf, node.position.y))

            // Rotate sprite to face movement direction
            if motionDirection.dx != 0 || motionDirection.dy != 0 {
                let angle = atan2(motionDirection.dy, motionDirection.dx) - .pi / 2
                node.zRotation = angle
            }
        }

        // Attack
        if input.attackPressed && (currentTime - attack.lastAttackTime) >= attack.cooldown {
            attack.isAttacking    = true
            attack.lastAttackTime = currentTime
        } else {
            attack.isAttacking = false
        }

        // Special
        if input.specialPressed && player.specialReady {
            player.specialReady  = false
            player.killStreak    = 0
            attack.isAttacking   = true
        }
    }
}
