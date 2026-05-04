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

    static func weekGroups(for date: Date = Date()) -> [DayGroup] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysFromMonday = (weekday + 5) % 7
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: date)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return (0..<7).compactMap { offset in
            let day = calendar.date(byAdding: .day, value: offset, to: monday)!
            let key = formatter.string(from: day)
            let daySessions = sessions.filter { $0.date == key }
            guard !daySessions.isEmpty else { return nil }
            return DayGroup(id: key, date: day, sessions: daySessions)
        }
    }

    static func monthGroups(for date: Date = Date()) -> [DayGroup] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDay = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: firstDay)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return range.compactMap { dayNum in
            guard let day = calendar.date(bySetting: .day, value: dayNum, of: firstDay) else { return nil }
            let key = formatter.string(from: day)
            let daySessions = sessions.filter { $0.date == key }
            guard !daySessions.isEmpty else { return nil }
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
