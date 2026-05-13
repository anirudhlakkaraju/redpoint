import SwiftUI

// MARK: - Draft models

struct ExerciseEntry: Identifiable {
    var id = UUID()
    var name = ""
    var sets: [SetEntry] = []
    var notes = ""
}

// MARK: - Extension

extension ManualEntryView {

    // MARK: - Lifting rows

    @ViewBuilder
    var weightTrainingRows: some View {
        let isActive = activeField == .target
        Button {
            activeField = .target
        } label: {
            HStack(spacing: 16) {
                Text("Target")
                    .foregroundStyle(.secondary)
                    .frame(width: 72, alignment: .leading)
                if target.isEmpty {
                    Text("Push / Pull / Legs...").foregroundStyle(Color.primary.opacity(0.25))
                } else {
                    Text(target)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(alignment: .bottom) {
                Rectangle()
                    .fill(isActive ? Color.red : Color.primary.opacity(0.1))
                    .frame(height: isActive ? 2 : 1)
                    .padding(.leading, 104)
            }
        }
        .buttonStyle(.plain)

        ForEach(exercises) { ex in
            exerciseListRow(ex)
        }

        addRowButton(label: "Add Exercise") {
            draftEx = ExerciseEntry()
            draftSet = SetEntry()
            editingExId = nil
            activeField = .exercise(nil)
        }
    }

    // MARK: - Exercise list row

    private func exerciseListRow(_ ex: ExerciseEntry) -> some View {
        Button {
            draftEx = ex
            draftSet = SetEntry()
            editingExId = ex.id
            activeField = .exercise(ex.id)
        } label: {
            HStack(spacing: 16) {
                Text(ex.name.isEmpty ? "Exercise" : ex.name)
                    .foregroundStyle(ex.name.isEmpty ? Color.primary.opacity(0.4) : .primary)
                    .frame(width: 72, alignment: .leading)
                Text(exerciseSummary(ex))
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(alignment: .bottom) {
                Rectangle().fill(Color.primary.opacity(0.1)).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Exercise panel

    var exercisePanel: some View {
        VStack(spacing: 10) {
            suggestionsRow(for: draftEx.name, pool: suggestions.exerciseNames) { draftEx.name = $0 }

            TextField("Exercise name", text: $draftEx.name)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal, 16)

            // Committed sets
            if !draftEx.sets.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(draftEx.sets.enumerated()), id: \.element.id) { idx, set in
                            Button {
                                draftEx.sets.remove(at: idx)
                            } label: {
                                Text(setChipLabel(set))
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(
                                        set.isWarmup
                                            ? Color.blue.opacity(0.15)
                                            : Color(.tertiarySystemBackground)
                                    )
                                    .foregroundStyle(set.isWarmup ? Color.blue : Color.primary)
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            // New set input row
            HStack(spacing: 8) {
                numericField("Reps", text: $draftSet.reps)
                Text("×").foregroundStyle(.secondary)
                numericField("Weight", text: $draftSet.weight, decimal: true)
                Picker("", selection: $draftSet.unit) {
                    ForEach(["lb", "kg", "bw"], id: \.self) { Text($0).tag($0) }
                }
                .frame(width: 55)
                Button {
                    draftSet.isWarmup.toggle()
                } label: {
                    Text("W")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 30, height: 34)
                        .background(draftSet.isWarmup ? Color.blue.opacity(0.2) : Color(.tertiarySystemBackground))
                        .foregroundStyle(draftSet.isWarmup ? Color.blue : Color.secondary)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)

            HStack(spacing: 8) {
                Button {
                    guard !draftSet.reps.isEmpty else { return }
                    draftEx.sets.append(draftSet)
                    draftSet = SetEntry(unit: draftSet.unit)
                } label: {
                    Text("+ Set")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(draftSet.reps.isEmpty ? Color.secondary.opacity(0.2) : Color.blue.opacity(0.15))
                        .foregroundStyle(draftSet.reps.isEmpty ? Color.secondary : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(draftSet.reps.isEmpty)
                .buttonStyle(.plain)

                commitButton(
                    label: editingExId == nil ? "Save Exercise" : "Update",
                    disabled: draftEx.name.isEmpty
                ) {
                    commitExercise()
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 10)
    }

    // MARK: - Helpers

    func setChipLabel(_ set: SetEntry) -> String {
        let warmup = set.isWarmup ? "w" : ""
        if set.weight.isEmpty || set.weight == "0" {
            return set.reps
        }
        return "\(set.weight)\(warmup)×\(set.reps)"
    }

    func exerciseSummary(_ ex: ExerciseEntry) -> String {
        guard !ex.sets.isEmpty else { return "" }
        let count = ex.sets.count
        let weights = ex.sets.compactMap { Double($0.weight) }.filter { $0 > 0 }
        if let min = weights.min(), let max = weights.max(), min != max {
            return "\(count) sets · \(Int(min))–\(Int(max)) \(ex.sets.first?.unit ?? "lb")"
        } else if let w = weights.first {
            return "\(count) sets · \(Int(w)) \(ex.sets.first?.unit ?? "lb")"
        }
        return "\(count) sets"
    }

    // MARK: - Commit

    private func commitExercise() {
        suggestions.addExercise(draftEx.name)
        if let id = editingExId, let idx = exercises.firstIndex(where: { $0.id == id }) {
            exercises[idx] = draftEx
        } else {
            exercises.append(draftEx)
        }
        draftEx = ExerciseEntry()
        draftSet = SetEntry()
        editingExId = nil
        activeField = .exercise(nil)
    }
}
