import Foundation
import GRDB

struct YogaSession: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var sessionId: Int64
    var style: String?
    var instructor: String?
    var notes: String?

    static let databaseTableName = "yoga"

    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case style
        case instructor
        case notes
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
