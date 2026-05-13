import Foundation

struct SetEntry: Identifiable {
    var id = UUID()
    var reps: String = ""
    var weight: String = ""
    var isWarmup: Bool = false
    var unit: String = "lb"
}
