import Foundation
import GRDB

struct ClimbingRoute: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var climbingSessionId: Int64
    var name: String
    var sent: Int
    var attempts: Int
    var grade: String?
    var notes: String?

    static let databaseTableName = "climbing_routes"

    enum CodingKeys: String, CodingKey {
        case id
        case climbingSessionId = "climbing_session_id"
        case name
        case sent
        case attempts
        case grade
        case notes
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
