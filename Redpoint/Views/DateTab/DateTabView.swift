import SwiftUI

enum DateSubtab: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct DateTabView: View {
    @State private var subtab: DateSubtab = .weekly

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $subtab) {
                ForEach(DateSubtab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 4)

            Divider()

            switch subtab {
            case .weekly:
                WeeklyLogView()
            case .daily:
                ContentUnavailableView("Daily View", systemImage: "calendar.day.timeline.left",
                                       description: Text("Coming soon"))
            case .monthly:
                ContentUnavailableView("Monthly View", systemImage: "calendar",
                                       description: Text("Coming soon"))
            }
        }
    }
}

#Preview {
    DateTabView()
}
