import Foundation
import GRDB

struct Session: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var date: String
    var sport: String
    var durationMinutes: Int?
    var notes: String
    var feel: Int?
    var source: String
    var imagePath: String?
    var createdAt: String

    var updatedAt: String?

    static let databaseTableName = "sessions"

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case sport
        case durationMinutes = "duration_minutes"
        case notes
        case feel
        case source
        case imagePath = "image_path"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
