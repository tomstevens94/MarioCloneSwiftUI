import SwiftUI

struct Entity {
    var id: UUID
}

extension Entity {
    init() {
        self.id = UUID()
    }
}
