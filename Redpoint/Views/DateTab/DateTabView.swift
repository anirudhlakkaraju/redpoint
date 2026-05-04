import SwiftUI

enum DateSubtab: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
}

struct DateTabView: View {
    @State private var subtab: DateSubtab = .daily
    @State private var currentDate: Date = Date()

    var body: some View {
        VStack(spacing: 0) {
            // Period navigation
            HStack {
                Button { navigate(-1) } label: {
                    Image(systemName: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)

                Spacer()

                Text(periodLabel)
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Button { navigate(1) } label: {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            // Daily / Weekly selector
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

            // Single divider below the entire header
            Rectangle()
                .fill(Color.primary.opacity(0.12))
                .frame(height: 1)

            switch subtab {
            case .weekly:
                WeeklyLogView(currentDate: currentDate)
            case .daily:
                DailyLogView(currentDate: currentDate)
            }
        }
    }

    // MARK: - Period label

    private var periodLabel: String {
        switch subtab {
        case .daily:
            return currentDate.formatted(.dateTime.month(.wide).year())
        case .weekly:
            let cal = Calendar.current
            let weekday = cal.component(.weekday, from: currentDate)
            let daysFromMonday = (weekday + 5) % 7
            let monday = cal.date(byAdding: .day, value: -daysFromMonday, to: currentDate)!
            let sunday = cal.date(byAdding: .day, value: 6, to: monday)!
            return weekRangeLabel(from: monday, to: sunday)
        }
    }

    private func weekRangeLabel(from start: Date, to end: Date) -> String {
        let startMonth = start.formatted(.dateTime.month(.abbreviated))
        let endMonth   = end.formatted(.dateTime.month(.abbreviated))
        let startDay   = start.formatted(.dateTime.day())
        let endDay     = end.formatted(.dateTime.day())
        let year       = end.formatted(.dateTime.year())

        if startMonth == endMonth {
            return "\(startMonth) \(startDay) – \(endDay), \(year)"
        } else {
            return "\(startMonth) \(startDay) – \(endMonth) \(endDay), \(year)"
        }
    }

    // MARK: - Navigation

    private func navigate(_ direction: Int) {
        let cal = Calendar.current
        switch subtab {
        case .daily:
            currentDate = cal.date(byAdding: .month, value: direction, to: currentDate) ?? currentDate
        case .weekly:
            currentDate = cal.date(byAdding: .weekOfYear, value: direction, to: currentDate) ?? currentDate
        }
    }
}

#Preview {
    DateTabView()
}
