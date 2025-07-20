import SwiftUI

class ControlSystem: Updatable {
    private var inputManager: InputManager
    
    init(inputManager: InputManager) {
        self.inputManager = inputManager
    }
    
    func update(componentManager: ComponentManager, deltaTime: Double) {
        let entities = componentManager.entitiesWith(
            allOf: [
                InputComponent.self,
                WalkComponent.self,
                VelocityComponent.self
            ]
        )
        
        let activeInputs = self.inputManager.activeInputs
        
        for entity in entities {
            for activeInput in activeInputs {
                if let input = componentManager.get(InputComponent.self, for: entity),
                   let walk = componentManager.get(WalkComponent.self, for: entity),
                   var velocity = componentManager.get(VelocityComponent.self, for: entity){
                    
                    guard input.acceptedInputs.contains(activeInput) else {
                        continue
                    }
                        
                    var walkSpeed = walk.speed
                        
                    if activeInput == .left {
                        walkSpeed *= -1
                    }
                    
                    velocity.dx += walkSpeed
                    
                    componentManager.add(velocity, to: entity)
                }
            }
        }
    }
}
