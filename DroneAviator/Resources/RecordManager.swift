import Foundation

struct ScoreRecord: Codable {
    var score: Double
    var name: String
}

class RecordManager {
    
    static let shared = RecordManager()
    
    private let userDefaults = UserDefaults.standard
    private let keyCoins = "coinRecords"
    private let keyTimer = "timerRecords"
    
    func isNewRecord(score: Double, gameType: gameType) -> Bool{
        var key: String!
        switch gameType {
        case .standart:
            key = "coinRecord"
        case .timer:
            key = "timerRecord"
        }
        if userDefaults.object(forKey: key) != nil {
            let record = userDefaults.object(forKey: key) as! Double
            if score > record  {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func addScoreRecord(score: Double, name: String, gameType: gameType) {
        var scoreRecords = getScoreRecords(gameType)
        let newRecord = ScoreRecord(score: score, name: name)
        scoreRecords.append(newRecord)
        var key: String!
        switch gameType {
        case .standart:
            key = keyCoins
        case .timer:
            key = keyTimer
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(scoreRecords) {
            userDefaults.set(encodedData, forKey: key)
        }
        switch gameType {
        case .standart:
            key = "coinRecord"
        case .timer:
            key = "timerRecord"
        }
        if userDefaults.object(forKey: key) != nil {
            let record = userDefaults.object(forKey: key) as! Double
            if score > record  {
                userDefaults.set(score, forKey: key)
            }
        } else {
            userDefaults.set(score, forKey: key)
        }
    }
    
    func getScoreRecords(_ gameType: gameType) -> [ScoreRecord] {
        var key: String!
        switch gameType {
        case .standart:
            key = keyCoins
        case .timer:
            key = keyTimer
        }
        if let data = userDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let scoreRecords = try? decoder.decode([ScoreRecord].self, from: data) {
                return scoreRecords
            }
        }
        return []
    }
    
}
