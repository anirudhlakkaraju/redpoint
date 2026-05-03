import SwiftUI

struct StatsView: View {
    var body: some View {
        ContentUnavailableView("Stats", systemImage: "chart.pie",
                               description: Text("Coming soon"))
    }
}

#Preview {
    StatsView()
}
