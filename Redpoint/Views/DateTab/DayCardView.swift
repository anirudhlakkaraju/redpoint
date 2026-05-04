import SwiftUI

struct DayCardView: View {
    let day: DayGroup

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.primary.opacity(0.15))
                .frame(height: 1)

            HStack(spacing: 8) {
                Text(dayNumber)
                    .font(.title2.weight(.bold))

                Text(dayAbbreviation)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(tagColor)
                    .cornerRadius(4)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Rectangle()
                .fill(Color.primary.opacity(0.15))
                .frame(height: 1)

            VStack(spacing: 8) {
                ForEach(day.sessions) { session in
                    SessionCardView(session: session)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Rectangle()
                .fill(Color.primary.opacity(0.15))
                .frame(height: 1)
        }
        .background(Color(.secondarySystemBackground))
    }

    private var dayNumber: String {
        day.date.formatted(.dateTime.day())
    }

    private var dayAbbreviation: String {
        day.date.formatted(.dateTime.weekday(.abbreviated)).uppercased()
    }

    private var tagColor: Color {
        let weekday = Calendar.current.component(.weekday, from: day.date)
        switch weekday {
        case 1: return .red
        case 7: return .blue
        default: return Color(.systemGray2)
        }
    }
}

#Preview {
    DayCardView(day: MockData.weekGroups(for: Date()).first!)
}
