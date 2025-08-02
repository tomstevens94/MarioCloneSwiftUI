import Foundation
class ECSManager {
    private var systems: [Updatable]
    
    private let renderSystem = RenderSystem()
    private let componentManager = ComponentManager()
    
    init(tileManager: TileManager, inputManager: InputManager) {
        systems = [
            ControlSystem(inputManager: inputManager),
            GravitySystem(),
            MovementSystem(),
            TileCollisionSystem(tileManager: tileManager, renderSystem: renderSystem),
            
            // Render system initialsed before init to enable parent access
            renderSystem
        ]
        
        self.createTileEntities(tileManager.tiles)
    }
    
    var drawCommands: [DrawCommand] {
        renderSystem.drawCommands
    }
    
    var debugDrawCommands: [DrawCommand] {
        renderSystem.debugDrawCommands
    }
    
    func createEntity() -> Entity {
        let newEntity = Entity()
        
        return newEntity
    }
    
    func createTileEntities(_ tilesData: [[TileData?]]) -> Void {
        for y in tilesData.indices {
            for x in tilesData[y].indices {
                guard let tileData = tilesData[y][x] else { continue }
                
                let tileEntity = Entity(id: tileData.entityId)
                
                self.componentManager.add(
                    TileComponent(size: tileData.size),
                    to: tileEntity
                )
                self.componentManager.add(
                    PositionComponent(
                        x: Double(x) * tileData.size.width,
                        y: Double(y) * tileData.size.height
                    ),
                    to: tileEntity
                )
                self.componentManager.add(
                    RenderComponent(
                        spriteName: .ground
                    ),
                    to: tileEntity
                )
            }
        }
    }
    
    func addComponentToEntity<TComponent>(_ component: TComponent, to entity: Entity) {
        self.componentManager.add(component, to: entity)
    }
    
    func update(_ deltaTime: Double) {
        // Draw commands cleared before update to enable systems debug rendering
        renderSystem.resetDrawCommands()
        
        for system in systems {
            system.update(
                componentManager: componentManager,
                deltaTime: deltaTime
            )
        }
    }
}
