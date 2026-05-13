import SwiftUI

struct CalDay {
    let date: Date
    let current: Bool  // belongs to displayed month
}

struct CalendarDatePicker: View {
    @Binding var date: Date
    @State private var displayedMonth: Date

    private static let cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 2  // week starts Monday
        return c
    }()

    private let headers = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    init(date: Binding<Date>) {
        _date = date
        _displayedMonth = State(initialValue: date.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 5) {
            // Month Navigation
            HStack {
                Button {
                    shift(-1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 60, height: 44)
                        .foregroundStyle(.primary)
                }
                Spacer()
                Text(monthLabel)
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Button {
                    shift(1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 60, height: 44)
                        .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal, 4)

            // Day-of-week headers
            HStack(spacing: 0) {
                ForEach(Array(headers.enumerated()), id: \.offset) { i, h in
                    Text(h)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(i == 5 ? Color.blue : i == 6 ? Color.red : Color.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            // Day grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
                spacing: 0
            ) {
                ForEach(gridDays, id: \.date) { day in
                    dayCell(day)
                }
            }
        }
    }

    private func dayCell(_ day: CalDay) -> some View {
        let sel = Self.cal.isDate(day.date, inSameDayAs: date)
        let wd = Self.cal.component(.weekday, from: day.date)  // 1=Sun 7=Sat
        let isSat = wd == 7
        let isSun = wd == 1

        return Button {
            date = day.date
            if !day.current { displayedMonth = day.date }
        } label: {
            Text("\(Self.cal.component(.day, from: day.date))")
                .font(.system(size: 15, weight: sel ? .semibold : .regular))
                .foregroundStyle(
                    !day.current
                        ? Color.primary.opacity(0.2)
                        : sel
                            ? Color(.systemBackground)
                            : isSat ? Color.blue : isSun ? Color.red : Color.primary
                )
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(sel ? Color.primary : Color.clear)
        }
        .buttonStyle(.plain)
    }

    private func shift(_ n: Int) {
        guard let m = Self.cal.date(byAdding: .month, value: n, to: displayedMonth) else { return }
        displayedMonth = m
    }

    private var monthLabel: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: displayedMonth)
    }

    private var gridDays: [CalDay] {
        guard let interval = Self.cal.dateInterval(of: .month, for: displayedMonth) else {
            return []
        }
        let start = interval.start
        let wdRaw = Self.cal.component(.weekday, from: start)
        let offset = (wdRaw - 2 + 7) % 7  // number of leading days from previous month

        return (0..<42).compactMap { i in
            guard let d = Self.cal.date(byAdding: .day, value: i - offset, to: start) else {
                return nil
            }
            let current = Self.cal.isDate(d, equalTo: displayedMonth, toGranularity: .month)
            return CalDay(date: d, current: current)
        }
    }
}
