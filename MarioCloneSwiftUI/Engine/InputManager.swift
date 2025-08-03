import Foundation

enum Input {
 case left, right
}

class InputManager {
    private(set) var activeInputs: Set<Input> = []
    
    func beginInput(input: Input) {
        activeInputs.insert(input)
    }
    
    func endInput(input: Input) {
        activeInputs.remove(input)
    }
}
