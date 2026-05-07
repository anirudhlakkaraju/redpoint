import Foundation
import GRDB

struct WeightTrainingSession: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var sessionId: Int64
    var target: String?
    var notes: String?

    static let databaseTableName = "weight_training"

    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case target
        case notes
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
