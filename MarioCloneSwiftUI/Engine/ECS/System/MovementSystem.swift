import SwiftUI

class MovementSystem: Updatable {
    func update(componentManager: ComponentManager, deltaTime: Double) {
        let entities = componentManager.entitiesWith(
            allOf: [PositionComponent.self, VelocityComponent.self]
        )
        
        for entity in entities {
            if var position = componentManager.get(PositionComponent.self, for: entity),
               let velocity = componentManager.get(VelocityComponent.self, for: entity) {
                position.x += (velocity.dx * deltaTime)
                position.y += (velocity.dy * deltaTime)
                
                componentManager.add(position, to: entity)
            }
        }
    }
}
