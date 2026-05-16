//
//  SessionRepository.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 5/7/26.
//

import Foundation
import GRDB

enum SessionDetail {
    case running(RunningSession)
    case weightTraining(WeightTrainingSession, [ExerciseEntry])
    case climbing(ClimbingSession, [ClimbingRoute])
    case yoga(YogaSession, [YogaPose])
}

final class SessionRepository {
    static let shared = SessionRepository()
    private var db: DatabasePool { DatabaseManager.shared.dbPool }
    private init() {}

    // MARK: - Write

    func save(session: Session, detail: SessionDetail) throws {
        var s = session
        try db.write({ database in
            try s.insert(database)
            guard let sessionId = s.id else { return }

            switch detail {
            case .running(var r):
                r.sessionId = sessionId
                try r.insert(database)

            case .weightTraining(var wt, let entries):
                wt.sessionId = sessionId
                try wt.insert(database)
                guard let wtId = wt.id else { return }
                for entry in entries {
                    var ex = Exercise(
                        id: nil, wtTrainingSessionId: wtId,
                        name: entry.name,
                        notes: entry.notes.isEmpty ? nil : entry.notes)
                    try ex.insert(database)
                    guard let exId = ex.id else { continue }
                    for (order, set) in entry.sets.enumerated() {
                        var row = ExerciseSet(
                            id: nil, exerciseId: exId,
                            reps: set.reps,
                            weight: Double(set.weight),
                            weightUnit: set.unit,
                            isWarmup: set.isWarmup,
                            setOrder: order)
                        try row.insert(database)
                    }
                }

            case .climbing(var c, let routes):
                c.sessionId = sessionId
                try c.insert(database)
                guard let cId = c.id else { return }
                for var route in routes {
                    route.climbingSessionId = cId
                    try route.insert(database)
                }

            case .yoga(var y, let poses):
                y.sessionId = sessionId
                try y.insert(database)
                guard let yId = y.id else { return }
                for var pose in poses {
                    pose.yogaSessionId = yId
                    try pose.insert(database)
                }
            }
        })
    }

    func delete(session: Session) throws {
        _ = try db.write { database in
            try session.delete(database)
        }
    }

    // MARK: - Read

    func sessionsForWeek(containing date: Date) throws -> [Session] {
        let (start, end) = weekBounds(for: date)
        return try db.read { database in
            try Session
                .filter(Column("date") >= start)
                .filter(Column("date") <= end)
                .order(Column("date").asc)
                .fetchAll(database)
        }
    }

    func sessionsForMonth(containing date: Date) throws -> [Session] {
        let (start, end) = monthBounds(for: date)
        return try db.read { database in
            try Session
                .filter(Column("date") >= start)
                .filter(Column("date") <= end)
                .order(Column("date").asc)
                .fetchAll(database)
        }
    }

    // MARK: - Helpers

    private func weekBounds(for date: Date) -> (String, String) {
        let cal = Calendar.current
        let weekday = cal.component(.weekday, from: date)
        let daysFromMonday = (weekday + 5) % 7
        let monday = cal.date(byAdding: .day, value: -daysFromMonday, to: date)!
        let sunday = cal.date(byAdding: .day, value: 6, to: monday)!
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return (fmt.string(from: monday), fmt.string(from: sunday))
    }

    private func monthBounds(for date: Date) -> (String, String) {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: date)
        let first = cal.date(from: comps)!
        let last = cal.date(byAdding: DateComponents(month: 1, day: -1), to: first)!
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return (fmt.string(from: first), fmt.string(from: last))
    }
}
