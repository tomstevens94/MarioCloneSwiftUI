import SwiftUI

class GameTimer {
    private var startTime: CFTimeInterval
    private var elapsedTime: CFTimeInterval
    private var timer: Timer?
    
    init() {
        self.startTime = CACurrentMediaTime()
        self.elapsedTime = 0
    }
    
    func start(_ onUpdate: @escaping (_: Double) -> Void) {
        self.stop()
        
        self.timer = Timer(timeInterval: 1 / 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentMediaTime = CACurrentMediaTime()
            
            let newElapsedTime = currentMediaTime - self.startTime
            let deltaTime = newElapsedTime - self.elapsedTime
            
            onUpdate(deltaTime)
            
            self.elapsedTime = newElapsedTime
        }
        
        guard let timer = self.timer else { return }
        
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    deinit {
        print("Deinitialising GameTimer")
        
        self.stop()
    }
}
