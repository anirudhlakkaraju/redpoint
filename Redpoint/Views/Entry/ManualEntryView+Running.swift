import SwiftUI

extension ManualEntryView {

    // MARK: - Running

    @ViewBuilder
    var runningRows: some View {
        inlineTextRow("Distance", text: $distanceMiles, placeholder: "miles", keyboard: .decimalPad)
        inlineTextRow("Time", text: $runTime, placeholder: "mm:ss")
        inlineTextRow("Pace", text: $pace, placeholder: "mm:ss/mi")
    }
}
