import SwiftUI

struct FullScreenControls: View {
    var inputManager: InputManager
    
    var body: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged{ _ in
                            inputManager.beginInput(
                                input: .left
                            )
                        }.onEnded{ _ in
                            inputManager.endInput(
                                input: .left
                            )
                        }
                )
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged{ _ in
                            print("IN RIGHT")
                            inputManager.beginInput(
                                input: .right
                            )
                        }.onEnded{ _ in
                            print("OUT RIGHT")
                            inputManager.endInput(
                                input: .right
                            )
                        }
                )
        }
    }
}
