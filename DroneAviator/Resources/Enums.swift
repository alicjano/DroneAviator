import Foundation

enum planeName: String, CaseIterable {
    case first = "plane1"
    case second = "plane2"
    case third = "plane3"
    case fourth = "plane4"
}

enum cannonName: String {
    case first = "drone1"
    case second = "drone2"
    case third = "drone3"
    case fourth = "drone4"
}

enum gameState {
    case notPlaying
    case playing
    case gameOver
}

enum gameType {
    case timer
    case standart
}
