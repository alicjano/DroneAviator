import Foundation

class GameManager {
    
    static let shared = GameManager()
    
    var gameType: gameType = .standart
    
    var round = 1
    
    var score = 0
    
    var plane: planeName = planeName(rawValue: UserDefaults.standard.object(forKey: "plane") as? String ?? "") ?? .first
    var cannon: cannonName = .first
    
    func restart(){
        round = 1
        score = 0
        cannon = .first
    }
    
    func nextLevel() {
        round += 1
        switch cannon  {
        case .first:
            cannon = .second
            break
        case .second:
            cannon = .third
        case .third:
            cannon = .fourth
        case.fourth:
            break
        }
    }
    
}
