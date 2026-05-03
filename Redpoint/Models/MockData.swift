import Foundation

struct MockSession: Identifiable {
    let id: UUID
    let date: String
    let sport: Sport
    let durationMinutes: Int?
    let notes: String
    let keyMetric: String
}

struct DayGroup: Identifiable {
    let id: String
    let date: Date
    var sessions: [MockSession]
}

struct MockData {
    static let sessions: [MockSession] = [
        MockSession(id: UUID(), date: currentWeekDateString(offset: 0),
                    sport: .running, durationMinutes: 45,
                    notes: "Easy recovery run, legs still tired",
                    keyMetric: "5.2 mi"),
        MockSession(id: UUID(), date: currentWeekDateString(offset: 1),
                    sport: .lifting, durationMinutes: 60,
                    notes: "Push day. New bench PR.",
                    keyMetric: "Push Day"),
        MockSession(id: UUID(), date: currentWeekDateString(offset: 2),
                    sport: .climbing, durationMinutes: 90,
                    notes: "Sent Panda finally. Racoon still a project.",
                    keyMetric: "90 min"),
        MockSession(id: UUID(), date: currentWeekDateString(offset: 2),
                    sport: .yoga, durationMinutes: 30,
                    notes: "Stretch + Breathe post-climb",
                    keyMetric: "30 min"),
        MockSession(id: UUID(), date: currentWeekDateString(offset: 4),
                    sport: .running, durationMinutes: 60,
                    notes: "Tempo run. Felt strong.",
                    keyMetric: "7.1 mi"),
    ]

    static func currentWeekGroups() -> [DayGroup] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return (0..<7).map { offset in
            let day = calendar.date(byAdding: .day, value: offset, to: monday)!
            let key = formatter.string(from: day)
            let daySessions = sessions.filter { $0.date == key }
            return DayGroup(id: key, date: day, sessions: daySessions)
        }
    }

    private static func currentWeekDateString(offset: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
        let day = calendar.date(byAdding: .day, value: offset, to: monday)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: day)
    }
}
