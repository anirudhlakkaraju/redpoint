import Foundation
import GRDB

struct RunningSession: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var sessionId: Int64
    
    var distance: Double?
    var unit: String?
    var timeSeconds: Int?
    var paceSeconds: Int?
    var notes: String?

    static let databaseTableName = "running"

    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case distance
        case unit
        case timeSeconds = "time_seconds"
        case paceSeconds = "pace_seconds"
        case notes
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
