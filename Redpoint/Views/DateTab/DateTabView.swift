import SwiftUI

enum DateSubtab: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
}

struct DateTabView: View {
    @State private var subtab: DateSubtab = .weekly

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(DateSubtab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.20)) {
                            subtab = tab
                        }
                    } label: {
                        VStack(spacing: 0) {
                            Text(tab.rawValue)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(subtab == tab ? 1.0 : 0.4))
                                .padding(.horizontal, 4)
                                .padding(.bottom, 8)

                            Rectangle()
                                .fill(subtab == tab ? Color.red : Color.clear)
                                .frame(height: 3)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 16)
                }
                Spacer()
            }

            Rectangle()
                .fill(Color.primary.opacity(0.12))
                .frame(height: 1)

            switch subtab {
            case .weekly:
                WeeklyLogView()
            case .daily:
                ContentUnavailableView("Daily View", systemImage: "calendar.day.timeline.left",
                                       description: Text("Coming soon"))
            }
        }
    }
}

#Preview {
    DateTabView()
}
