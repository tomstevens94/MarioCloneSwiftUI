import SwiftUI

struct CollisionData {
    var overlapX: Double
    var overlapY: Double
    var lazyDistance: Double
    var normal: CGVector
}

class TileCollisionSystem: Updatable {
    let tileManager: TileManager
    let renderSystem: RenderSystem
    
    init(tileManager: TileManager, renderSystem: RenderSystem) {
        self.tileManager = tileManager
        self.renderSystem = renderSystem
    }
    
    func update(componentManager: ComponentManager, deltaTime: Double) {
        let activeEntities = componentManager.entitiesWith(
            allOf: [TileCollisionComponent.self, PositionComponent.self, VelocityComponent.self]
        )
        
        for entity in activeEntities {
            if let collision = componentManager.get(TileCollisionComponent.self, for: entity),
               var position = componentManager.get(PositionComponent.self, for: entity),
               var velocity = componentManager.get(VelocityComponent.self, for: entity) {
                
                // Broad phase collision
                let broadPhaseCollisions = tileManager.getBroadPhaseCollisions(at: position, entitySize: collision.size)
                guard broadPhaseCollisions.count > 0 else { continue }
                
                let entityMinX = position.x
                let entityMaxX = position.x + collision.size.width
                
                let entityMinY = position.y
                let entityMaxY = position.y + collision.size.height
                
                let entityCenterX = position.x + (collision.size.width / 2)
                let entityCenterY = position.y + (collision.size.height / 2)
                
                let narrowPhaseCollisions: [CollisionData] = broadPhaseCollisions.compactMap { tile -> CollisionData? in
                    guard let tilePositionComponent = componentManager.getById(PositionComponent.self, for: tile.entityId),
                          let tileComponent = componentManager.getById(TileComponent.self, for: tile.entityId) else { return nil }
                    
                    // Debug rendering of broad phase collisions
                    renderSystem.debugDrawCommands.append(
                        .rect(
                            RectDrawCommand(
                                color: .yellow,
                                at: .init(
                                    x: tilePositionComponent.x,
                                    y: tilePositionComponent.y,
                                    width: tileComponent.size.width,
                                    height: tileComponent.size.height
                                )
                            )
                        )
                    )
                    
                    let tileMinX = tilePositionComponent.x
                    let tileMaxX = tilePositionComponent.x + tileComponent.size.width
                    
                    let tileMinY = tilePositionComponent.y
                    let tileMaxY = tilePositionComponent.y + tileComponent.size.height
                    
                    let tileCenterX = tilePositionComponent.x + (tileComponent.size.width / 2)
                    let tileCenterY = tilePositionComponent.y + (tileComponent.size.height / 2)
                    
                    let collides =
                        entityMinX < tileMaxX &&
                        entityMaxX > tileMinX &&
                        entityMinY < tileMaxY &&
                        entityMaxY > tileMinY
                    
                    guard collides else { return nil }
                    
                    // Debug rendering of narrow phase collisions
                    renderSystem.debugDrawCommands.append(
                        .rect(
                            RectDrawCommand(
                                color: .red,
                                at: .init(
                                    x: tilePositionComponent.x,
                                    y: tilePositionComponent.y,
                                    width: tileComponent.size.width,
                                    height: tileComponent.size.height
                                )
                            )
                        )
                    )
                    
                    let overlapX = min(abs(entityMaxX - tileMinX), abs(entityMinX - tileMaxX))
                    let overlapY = min(abs(entityMaxY - tileMinY), abs(entityMinY - tileMaxY))
                    
                    return CollisionData(
                        overlapX: overlapX,
                        overlapY: overlapY,
                        lazyDistance: abs(tileCenterX - entityCenterX) + abs(tileCenterY - entityCenterY),
                        normal: overlapX < overlapY ?
                            CGVector(
                            dx: (entityCenterX - tileCenterX) / abs(entityCenterX - tileCenterX),
                            dy: 0
                        ) : CGVector(
                            dx: 0,
                            dy: (entityCenterY - tileCenterY) / abs(entityCenterY - tileCenterY)
                        )
                    )
                }
                
                guard narrowPhaseCollisions.count > 0 else { continue }
                
                let sorted = narrowPhaseCollisions.sorted {
                    $0.lazyDistance < $1.lazyDistance
                }
                
                var resolvedVectors: [CGVector] = []
                
                sorted.forEach { collision in
                    if resolvedVectors.contains(collision.normal) {
                        return
                    }
                    
                    if collision.normal.dy != 0 {
                        position.y += collision.overlapY * collision.normal.dy
                        velocity.dy = 0
                    } else {
                        print(collision.normal)
                        position.x += collision.overlapX * collision.normal.dx
                    }
                    
                    resolvedVectors.append(collision.normal)
                }
                
                componentManager.add(velocity, to: entity)
                componentManager.add(position, to: entity)
            }
        }
    }
}
