import Foundation
import Combine

final class SuggestionsStore: ObservableObject {
    @Published var exerciseNames: [String]
    @Published var routeNames: [String]
    @Published var poseNames: [String]

    init() {
        exerciseNames = UserDefaults.standard.stringArray(forKey: "savedExerciseNames") ?? []
        routeNames    = UserDefaults.standard.stringArray(forKey: "savedRouteNames")    ?? []
        poseNames     = UserDefaults.standard.stringArray(forKey: "savedPoseNames")     ?? []
    }

    func addExercise(_ name: String) { add(name, to: &exerciseNames, key: "savedExerciseNames") }
    func addRoute(_ name: String)    { add(name, to: &routeNames,    key: "savedRouteNames")    }
    func addPose(_ name: String)     { add(name, to: &poseNames,     key: "savedPoseNames")     }

    private func add(_ name: String, to list: inout [String], key: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !list.contains(trimmed) else { return }
        list.append(trimmed)
        UserDefaults.standard.set(list, forKey: key)
    }
}
