import SwiftUI

class GravitySystem: Updatable {
    func update(componentManager: ComponentManager, deltaTime: Double) {
        let entities = componentManager.entitiesWith(
            allOf: [MassComponent.self, VelocityComponent.self]
        )
        
        for entity in entities {
            if let _ = componentManager.get(MassComponent.self, for: entity),
               var velocity = componentManager.get(VelocityComponent.self, for: entity){
                velocity.dy += 1300 * deltaTime
                
                componentManager.add(velocity, to: entity)
            }
        }
    }
}
