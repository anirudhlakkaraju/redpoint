import Foundation

enum Sport: String, CaseIterable, Identifiable {
    case running = "Running"
    case lifting = "Lifting"
    case climbing = "Climbing"
    case yoga = "Yoga"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .lifting: return "dumbbell"
        case .climbing: return "mountain.2"
        case .yoga: return "figure.yoga"
        }
    }
}
