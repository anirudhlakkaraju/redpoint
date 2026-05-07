import Foundation
import GRDB

struct YogaPose: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var yogaSessionId: Int64
    var name: String

    static let databaseTableName = "yoga_poses"

    enum CodingKeys: String, CodingKey {
        case id
        case yogaSessionId = "yoga_session_id"
        case name
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
