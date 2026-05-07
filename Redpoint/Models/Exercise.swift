import Foundation
import GRDB

struct Exercise: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var wtTrainingSessionId: Int64
    var name: String
    var sets: Int?
    var reps: Int?
    var weight: Double?
    var weightUnit: String?
    var notes: String?

    static let databaseTableName = "exercises"

    enum CodingKeys: String, CodingKey {
        case id
        case wtTrainingSessionId = "wt_training_session_id"
        case name
        case sets
        case reps
        case weight
        case weightUnit = "weight_unit"
        case notes
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
