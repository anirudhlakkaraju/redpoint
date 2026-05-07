import Foundation
import GRDB

struct ClimbingSession: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var sessionId: Int64
    var type: String?

    static let databaseTableName = "climbing"

    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case type
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
