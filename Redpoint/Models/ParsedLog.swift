import Foundation

struct ParsedLog: Decodable, Identifiable {
    var id: UUID = UUID()
    var days: [ParsedDay]

    enum CodingKeys: String, CodingKey {
        case days
    }
}

struct ParsedDay: Decodable, Identifiable {
    var id: String { date }
    var date: String
    var sessions: [ParsedSession]
}

struct ParsedSession: Decodable, Identifiable {
    var id: UUID = UUID()
    var sport: String
    var durationMinutes: Int?
    var notes: String?
    var feel: Int?
    // Running
    var distanceMiles: Double?
    var time: String?
    var pace: String?
    // Weight training
    var target: String?
    var exercises: [ParsedExercise]?
    // Climbing
    var type: String?
    var routes: [ParsedRoute]?
    // Yoga
    var style: String?
    var instructor: String?
    var poses: [String]?

    enum CodingKeys: String, CodingKey {
        case sport, notes, feel, time, pace, target, exercises, type, routes, style, instructor, poses
        case durationMinutes = "duration_minutes"
        case distanceMiles = "distance_miles"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sport = try c.decode(String.self, forKey: .sport)
        durationMinutes = try c.decodeIfPresent(Int.self, forKey: .durationMinutes)
        notes = try c.decodeIfPresent(String.self, forKey: .notes)
        feel = try c.decodeIfPresent(Int.self, forKey: .feel)
        distanceMiles = try c.decodeIfPresent(Double.self, forKey: .distanceMiles)
        time = try c.decodeIfPresent(String.self, forKey: .time)
        pace = try c.decodeIfPresent(String.self, forKey: .pace)
        target = try c.decodeIfPresent(String.self, forKey: .target)
        exercises = try c.decodeIfPresent([ParsedExercise].self, forKey: .exercises)
        type = try c.decodeIfPresent(String.self, forKey: .type)
        routes = try c.decodeIfPresent([ParsedRoute].self, forKey: .routes)
        style = try c.decodeIfPresent(String.self, forKey: .style)
        instructor = try c.decodeIfPresent(String.self, forKey: .instructor)
        poses = try c.decodeIfPresent([String].self, forKey: .poses)
    }
}

struct ParsedExercise: Decodable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var sets: Int?
    var reps: Int?
    var weight: Double?
    var weightUnit: String?
    var notes: String?

    enum CodingKeys: String, CodingKey {
        case name, sets, reps, weight, notes
        case weightUnit = "weight_unit"
    }
}

struct ParsedRoute: Decodable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var sent: Bool
    var attempts: Int?
    var grade: String?
    var notes: String?
}
