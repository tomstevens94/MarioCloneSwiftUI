import SwiftUI

struct Sprite {
    let image: CGImage
}

enum SpriteName {
    case marioIdle, ground, sky
}

enum SpriteImageName {
    case Characters, Tiles
}

extension ContentView {
    @Observable
    
    class ViewModel {
        private(set) var spriteSourceImages = [SpriteImageName: CGImage]()
        private(set) var sprites = [SpriteName: Sprite]()
        
        private(set) var timer: GameTimer
        private(set) var inputManager: InputManager
        private(set) var ecsManager: ECSManager
        private(set) var tileManager: TileManager
        
        var position = CGPoint(x: 20, y: 20)
        var drawCommands: [DrawCommand] = []
        var debugDrawCommands: [DrawCommand] = []
        var backgroundDrawCommands: [DrawCommand] = []
        
        private func update(_ deltaTime: Double) {
            ecsManager.update(deltaTime)
            
            drawCommands = ecsManager.drawCommands
            debugDrawCommands = ecsManager.debugDrawCommands
        }
        
        private func generateBackgroundDrawCommands() -> [DrawCommand] {
            var commands: [DrawCommand] = []
            
            for x in 0..<30 {
                for y in 0..<12 {
                    commands.append(
                        .sprite(
                            SpriteDrawCommand(
                                spriteName: .sky,
                                at: .init(x: Double(x) * 16.0, y: Double(y) * 16.0)
                            )
                        )
                    )
                }
            }
            
            return commands
        }
        
        init() {
            self.timer = GameTimer()
            
            let inputManager = InputManager()
            self.inputManager = inputManager
            
            let tileManager = TileManager()
            self.tileManager = tileManager
            
            self.ecsManager = ECSManager(
                tileManager: tileManager,
                inputManager: inputManager
            )
            
            backgroundDrawCommands = generateBackgroundDrawCommands()
            
            let mario = ecsManager.createEntity()
            
            ecsManager.addComponentToEntity(
                PositionComponent(x: 110.0, y: 20.0),
                to: mario
            )
            ecsManager.addComponentToEntity(
                VelocityComponent(dx: 0, dy: 0),
                to: mario
            )
            ecsManager.addComponentToEntity(
                MassComponent(10.0),
                to: mario
            )
            ecsManager.addComponentToEntity(
                TileCollisionComponent(size: .init(width: 14, height: 16)),
                to: mario
            )
            ecsManager.addComponentToEntity(
                RenderComponent(spriteName: .marioIdle),
                to: mario
            )
            ecsManager.addComponentToEntity(
                InputComponent(
                    acceptedInputs: Set(
                        [.left, .right]
                    )
                ),
                to: mario
            )
            ecsManager.addComponentToEntity(
                WalkComponent(speed: 1),
                to: mario
            )
            
            guard let charactersSourceImage = UIImage(named: "characters")?.cgImage,
                let tilesSourceImage = UIImage(named: "tiles")?.cgImage  else { return }

            spriteSourceImages[.Characters] = charactersSourceImage
            spriteSourceImages[.Tiles] = tilesSourceImage
            
            self.defineSprite(.marioIdle, spriteImageName: .Characters, rect: CGRect(x: 276, y: 44, width: 14, height: 16))
            self.defineSprite(.ground, spriteImageName: .Tiles, rect: CGRect(x: 0, y: 0, width: 16, height: 16))
            self.defineSprite(.sky, spriteImageName: .Tiles, rect: CGRect(x: 48, y: 368, width: 16, height: 16))
            
            self.timer.start(update)
        }
        
        func defineSprite(_ name: SpriteName, spriteImageName: SpriteImageName, rect: CGRect) {
            guard let sourceImage = spriteSourceImages[spriteImageName],
                  let cropped = sourceImage.cropping(to: rect) else { return }
            
            let sprite: CGImage = {
                cropped
            }()
            
            sprites[name] = .init(image: sprite);
        }
    }
}

#Preview {
    ContentView()
}
