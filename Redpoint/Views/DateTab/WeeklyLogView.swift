import SwiftUI

struct WeeklyLogView: View {
    private var weekDays: [DayGroup] { MockData.currentWeekGroups() }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(weekDays) { day in
                    DayHeaderView(date: day.date)
                    ForEach(day.sessions) { session in
                        SessionCardView(session: session)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }
                    if day.sessions.isEmpty {
                        Spacer().frame(height: 8)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
}

struct DayHeaderView: View {
    let date: Date

    var body: some View {
        HStack(spacing: 6) {
            Text(date.formatted(.dateTime.weekday(.wide)))
                .font(.subheadline.weight(.semibold))
            Text(date.formatted(.dateTime.month(.abbreviated).day()))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 6)
    }
}

#Preview {
    WeeklyLogView()
}
