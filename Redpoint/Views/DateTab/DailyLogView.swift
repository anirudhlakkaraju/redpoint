import SwiftUI

struct DailyLogView: View {
    let currentDate: Date
    private var monthDays: [DayGroup] { MockData.monthGroups(for: currentDate) }

    var body: some View {
        if monthDays.isEmpty {
            ContentUnavailableView("No Sessions", systemImage: "figure.run.circle",
                                   description: Text("No workouts logged this month"))
        } else {
            ScrollView {
                VStack(spacing: 5) {
                    ForEach(monthDays) { day in
                        DayCardView(day: day)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    DailyLogView(currentDate: Date())
}
