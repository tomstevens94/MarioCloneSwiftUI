import SwiftUI

let DRAG = 0.96

class MovementSystem: Updatable {
    func update(componentManager: ComponentManager, deltaTime: Double) {
        let entities = componentManager.entitiesWith(
            allOf: [PositionComponent.self, VelocityComponent.self]
        )
        
        for entity in entities {
            if var position = componentManager.get(PositionComponent.self, for: entity),
               var velocity = componentManager.get(VelocityComponent.self, for: entity) {
                position.x += (velocity.dx * deltaTime)
                position.y += (velocity.dy * deltaTime)
                
                velocity.dx *= DRAG
                
                componentManager.add(position, to: entity)
                componentManager.add(velocity, to: entity)
            }
        }
    }
}
