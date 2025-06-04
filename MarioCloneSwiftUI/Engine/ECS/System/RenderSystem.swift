import SwiftUI
import Foundation

struct SpriteDrawCommand: Hashable {
    var spriteName: SpriteName
    var at: CGPoint
}

struct RectDrawCommand: Hashable {
    var color: Color
    var at: CGRect
}

enum DrawCommand: Hashable {
    case sprite(SpriteDrawCommand)
    case rect(RectDrawCommand)
}

class RenderSystem: Updatable {
    var drawCommands: [DrawCommand] = []
    var debugDrawCommands: [DrawCommand] = []
    
    func resetDrawCommands() -> Void {
        drawCommands.removeAll()
        debugDrawCommands.removeAll()
    }
    
    func update(componentManager: ComponentManager, deltaTime: Double) {
        let entities = componentManager.entitiesWith(
            allOf: [RenderComponent.self, PositionComponent.self]
        )
        
        for entity in entities {
            if let render = componentManager.get(RenderComponent.self, for: entity),
               let position = componentManager.get(PositionComponent.self, for: entity) {
                
                let tileComponent = componentManager.get(TileComponent.self, for: entity)
                
                let drawCommand = DrawCommand.sprite(
                    SpriteDrawCommand(
                        spriteName: render.spriteName,
                        at: position
                    )
                )
                
                drawCommands.append(drawCommand)
                
                if tileComponent == nil {
                    debugDrawCommands.append(
                        .rect(
                            RectDrawCommand(
                                color: .blue,
                                at: .init(
                                    x: position.x,
                                    y: position.y,
                                    width: 14,
                                    height: 16
                                )
                            )
                        )
                    )
                }
            }
        }
    }
}
