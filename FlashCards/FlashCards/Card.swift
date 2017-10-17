import Foundation
import UIKit

struct Card: Codable, Equatable {
    let front: String
    let back: String
    let id: UUID
    var frontImage: String?
    var backImage: String?
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(front: String, back: String, id: UUID) {
        self.front = front
        self.back = back
        self.id = id
    }
}
