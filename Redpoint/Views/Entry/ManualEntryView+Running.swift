import SwiftUI

extension ManualEntryView {

    // MARK: - Running

    @ViewBuilder
    var runningRows: some View {
        fieldRow("Time", value: runTimeDisplay, field: .runTime)
        fieldRow("Distance", value: distanceDisplay, field: .runDistance)
        fieldRow("Pace", value: paceDisplay, field: .runPace)
    }
    
    var runTimeDisplay: String {
        let total = runHours * 3600 + runMinutes * 60 + runSeconds
        guard total > 0 else { return "" }
        
        return String(format: "%d:%02d:%02d", runHours, runMinutes, runSeconds)
    }
    
    var distanceDisplay: String {
        guard distanceWhole > 0 || distanceFraction > 0 else { return "" }
        return "\(distanceWhole).\(distanceFraction) \(runUnit)"
    }
    
    var paceDisplay: String {
        guard paceMinutes > 0 || paceSeconds > 0 else { return "" }
        return String(format: "%d:%02d /\(runUnit)", paceMinutes, paceSeconds)
    }
    
    func recomputePace() {
        let totalSecs = runHours * 3600 + runMinutes * 60 + runSeconds
        let dist = Double(distanceWhole) + Double(distanceFraction) / 10.0
        
        guard totalSecs > 0, dist > 0 else { return }
        let pace = Int(Double(totalSecs) / dist)
        
        paceMinutes = pace / 60
        paceSeconds = pace % 60
    }
}
