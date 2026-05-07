import Foundation

enum Sport: String, CaseIterable, Identifiable {
    case running = "Running"
    case lifting = "Lifting"
    case climbing = "Climbing"
    case yoga = "Yoga"

    var id: String { rawValue }

    var dbValue: String {
        switch self {
        case .running:  return "running"
        case .lifting:  return "weight_training"
        case .climbing: return "climbing"
        case .yoga:     return "yoga"
        }
    }

    static func from(apiString: String) -> Sport? {
        switch apiString.lowercased() {
        case "running":         return .running
        case "weight_training": return .lifting
        case "climbing":        return .climbing
        case "yoga":            return .yoga
        default:                return nil
        }
    }

    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .lifting: return "dumbbell"
        case .climbing: return "mountain.2"
        case .yoga: return "figure.yoga"
        }
    }
}
