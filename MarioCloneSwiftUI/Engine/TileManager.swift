import SwiftUI

enum TileName {
    case ground
}

struct TileData {
    var entityId: UUID
    var name: TileName
    var size: CGSize
}

class TileManager {
    var tiles: [[TileData?]] = []
    private var tileSize = 16.0
    
    init() {
        let width = 30
        let height = 12
        
        let groundHeight = 2
        
        // Create grid of nil
        for _ in 0..<height {
            let row: [TileData?] = Array(repeating: nil, count: width)
            
            tiles.append(row)
        }
        
        // Add tiles where needed
        for y in height - groundHeight..<height {
            for x in 0..<width {
                tiles[y][x] = .init(
                    entityId: UUID(),
                    name: .ground,
                    size: .init(width: tileSize, height: tileSize)
                )
            }
        }
        
        tiles[8][2] = .init(
            entityId: UUID(),
            name: .ground,
            size: .init(width: tileSize, height: tileSize)
        )
        
        tiles[9][3] = .init(
            entityId: UUID(),
            name: .ground,
            size: .init(width: tileSize, height: tileSize)
        )
        
        tiles[9][6] = .init(
            entityId: UUID(),
            name: .ground,
            size: .init(width: tileSize, height: tileSize)
        )
        
        tiles[10][11] = nil
        tiles[11][11] = nil
        tiles[10][12] = nil
        tiles[11][12] = nil
    }
    
    func getBroadPhaseCollisions(at entityPosition: CGPoint, entitySize: CGSize) -> [TileData] {
        let xMin = floor(entityPosition.x / tileSize)
        let yMin = floor(entityPosition.y / tileSize)
        let xMax = ceil((entityPosition.x + entitySize.width) / tileSize)
        let yMax = ceil((entityPosition.y + entitySize.height) / tileSize)
        
        var collisions: [TileData] = []
        
        for x in stride(from: Int(xMin), to: Int(xMax), by: 1) {
            for y in stride(from: Int(yMin), to: Int(yMax), by: 1) {
                if tiles.count > y && tiles[y].count > x {
                    guard let tile = tiles[y][x] else { continue }
                    
                    collisions.append(tile)
                }
            }
        }
        
        return collisions
    }
}
