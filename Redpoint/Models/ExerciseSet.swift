import Foundation
import GRDB

struct ExerciseSet: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var exerciseId: Int64
    var reps: String
    var weight: Double?
    var weightUnit: String?
    var isWarmup: Bool
    var setOrder: Int

    static let databaseTableName = "exercise_sets"

    enum CodingKeys: String, CodingKey {
        case id
        case exerciseId = "exercise_id"
        case reps
        case weight
        case weightUnit = "weight_unit"
        case isWarmup = "is_warmup"
        case setOrder = "set_order"
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
