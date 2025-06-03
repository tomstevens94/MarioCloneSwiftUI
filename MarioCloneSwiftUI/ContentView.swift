//
//  ContentView.swift
//  MarioCloneSwiftUI
//
//  Created by Tom Stevens on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    let viewModel = ViewModel();

    let gridHeight = 15;
    let screenHeight = UIScreen.main.bounds;
    
    let spriteScale: CGFloat = 2.0;
    
    func drawSprite(_ spriteName: SpriteName, at position: CGPoint, context: GraphicsContext) -> Void {
        let sprite = viewModel.sprites[spriteName];
        guard let sprite = sprite else { return };
        
        context.draw(
            Image(decorative: sprite.image, scale: 1.0).interpolation(.none),
            at: position,
            anchor: .zero
        )
    }
    
    func executeDrawCommands(_ drawCommands: [DrawCommand], on context: GraphicsContext) -> Void {
        for drawCommand in drawCommands {
            switch drawCommand {
            case .sprite(let spriteCommand):
                drawSprite(
                    spriteCommand.spriteName,
                    at: spriteCommand.at,
                    context: context
                )
            case .rect(let rectCommand):
                context.stroke(
                    Path(rectCommand.at),
                    with: .color(rectCommand.color),
                    lineWidth: 1
                )
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Canvas() { context, size in
                context.scaleBy(x: size.height / (12.0 * 16.0), y: size.height / (12.0 * 16.0))
                
                executeDrawCommands(viewModel.backgroundDrawCommands, on: context)
                executeDrawCommands(viewModel.drawCommands, on: context)
                executeDrawCommands(viewModel.debugDrawCommands, on: context)
            }
            
            Button("Press") {
                print("PRESSED")
            }
            .padding(32)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
