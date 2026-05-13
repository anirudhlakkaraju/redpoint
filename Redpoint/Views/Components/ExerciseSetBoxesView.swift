import SwiftUI

struct ExerciseSetBoxesView: View {
    let name: String
    let sets: [SetEntry]
    let notes: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(sets) { set in
                        SetBox(set: set)
                    }
                }
            }

            if let notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(alignment: .bottom) {
            Rectangle().fill(Color.primary.opacity(0.08)).frame(height: 1)
        }
    }
}

private struct SetBox: View {
    let set: SetEntry

    private var showWeight: Bool {
        !set.weight.isEmpty && set.weight != "0"
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(set.reps)
                .font(.subheadline)
                .fontWeight(.bold)
            if showWeight {
                Text("\(set.weight) \(set.unit)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(minWidth: 44)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(set.isWarmup ? Color.blue.opacity(0.12) : Color(.tertiarySystemBackground))
        .foregroundStyle(set.isWarmup ? Color.blue : Color.primary)
        .cornerRadius(8)
    }
}

#Preview {
    ExerciseSetBoxesView(
        name: "Incline DB Press",
        sets: [
            SetEntry(reps: "6", weight: "40", isWarmup: true, unit: "lb"),
            SetEntry(reps: "5", weight: "55", isWarmup: false, unit: "lb"),
            SetEntry(reps: "6", weight: "55", isWarmup: false, unit: "lb"),
            SetEntry(reps: "6", weight: "50", isWarmup: false, unit: "lb"),
        ],
        notes: "Good, felt the burn, tough"
    )
}
