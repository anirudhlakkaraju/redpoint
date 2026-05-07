import Foundation
import GRDB

struct RunningSession: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var sessionId: Int64
    var distanceMiles: Double?
    var time: String?
    var pace: String?
    var notes: String?

    static let databaseTableName = "running"

    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case distanceMiles = "distance_miles"
        case time
        case pace
        case notes
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
