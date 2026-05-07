import SwiftUI

// MARK: - Form helper structs (local to this file, not DB models)

struct ExerciseEntry: Identifiable {
    var id = UUID()
    var name: String = ""
    var sets: String = ""
    var reps: String = ""
    var weight: String = ""
    var weightUnit: String = "lb"
    var notes: String = ""
}

struct RouteEntry: Identifiable {
    var id = UUID()
    var name: String = ""
    var sent: Bool = false
    var attempts: String = "1"
    var grade: String = ""
    var notes: String = ""
}

struct PoseEntry: Identifiable {
    var id = UUID()
    var name: String = ""
}

// MARK: - Main view

struct ManualEntryView: View {
    @Environment(\.dismiss) private var dismiss

    // Common
    @State private var sport: Sport = .running
    @State private var date: Date = Date()
    @State private var durationMinutes: String = ""
    @State private var notes: String = ""
    @State private var feel: Int = 0
    @State private var isSaving = false
    @State private var errorMessage: String?

    // Running
    @State private var distanceMiles: String = ""
    @State private var runTime: String = ""
    @State private var pace: String = ""

    // Weight training
    @State private var target: String = ""
    @State private var exercises: [ExerciseEntry] = [ExerciseEntry()]

    // Climbing
    @State private var climbType: String = ""
    @State private var routes: [RouteEntry] = [RouteEntry()]

    // Yoga
    @State private var style: String = ""
    @State private var instructor: String = ""
    @State private var poses: [PoseEntry] = [PoseEntry()]

    var body: some View {
        NavigationStack {
            Form {
                // Sport picker
                Section {
                    HStack(spacing: 0) {
                        ForEach(Sport.allCases) { s in
                            Button {
                                sport = s
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: s.icon)
                                        .font(.title3)
                                    Text(s.rawValue)
                                        .font(.caption2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(sport == s ? Color.red.opacity(0.15) : Color.clear)
                                .foregroundStyle(sport == s ? Color.red : Color.primary.opacity(0.5))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Common fields
                Section("Session") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    HStack {
                        Text("Duration")
                        Spacer()
                        TextField("0", text: $durationMinutes)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 50)
                        Text("min").foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Feel")
                        Spacer()
                        ForEach(1...5, id: \.self) { i in
                            Button {
                                feel = (feel == i) ? 0 : i
                            } label: {
                                Image(systemName: i <= feel ? "star.fill" : "star")
                                    .foregroundStyle(i <= feel ? .yellow : Color.primary.opacity(0.3))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }

                // Sport-specific fields
                switch sport {
                case .running:
                    runningSection
                case .lifting:
                    weightTrainingSection
                case .climbing:
                    climbingSection
                case .yoga:
                    yogaSection
                }
            }
            .navigationTitle("Log Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(isSaving)
                }
            }
            .overlay {
                if let error = errorMessage {
                    VStack {
                        Spacer()
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.red.opacity(0.85))
                            .cornerRadius(8)
                            .padding()
                    }
                }
            }
        }
    }

    // MARK: - Sport sections

    private var runningSection: some View {
        Section("Run Details") {
            HStack {
                Text("Distance")
                Spacer()
                TextField("0.0", text: $distanceMiles)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("mi").foregroundStyle(.secondary)
            }
            HStack {
                Text("Time")
                Spacer()
                TextField("mm:ss", text: $runTime)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
            }
            HStack {
                Text("Pace")
                Spacer()
                TextField("mm:ss/mi", text: $pace)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
            }
        }
    }

    private var weightTrainingSection: some View {
        Section("Workout Details") {
            TextField("Target (e.g. Push, Legs + Pull)", text: $target)

            ForEach($exercises) { $ex in
                VStack(alignment: .leading, spacing: 6) {
                    TextField("Exercise name", text: $ex.name)
                        .font(.subheadline.weight(.medium))
                    HStack {
                        TextField("Sets", text: $ex.sets)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: .infinity)
                        Text("×").foregroundStyle(.secondary)
                        TextField("Reps", text: $ex.reps)
                            .keyboardType(.numberPad)
                            .frame(maxWidth: .infinity)
                        TextField("Weight", text: $ex.weight)
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: .infinity)
                        Picker("", selection: $ex.weightUnit) {
                            Text("lb").tag("lb")
                            Text("kg").tag("kg")
                            Text("kb").tag("kb")
                            Text("bw").tag("bw")
                        }
                        .frame(width: 50)
                    }
                    .font(.caption)
                    TextField("Notes", text: $ex.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .onDelete { exercises.remove(atOffsets: $0) }

            Button { exercises.append(ExerciseEntry()) } label: {
                Label("Add Exercise", systemImage: "plus.circle")
            }
        }
    }

    private var climbingSection: some View {
        Section("Climbing Details") {
            HStack {
                Text("Type")
                Spacer()
                Picker("", selection: $climbType) {
                    Text("Boulder").tag("boulder")
                    Text("Route").tag("route")
                    Text("Mixed").tag("mixed")
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }

            ForEach($routes) { $route in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        TextField("Route / project name", text: $route.name)
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        Toggle("Sent", isOn: $route.sent)
                            .labelsHidden()
                            .tint(.green)
                    }
                    HStack {
                        TextField("Grade", text: $route.grade)
                            .frame(maxWidth: .infinity)
                        HStack(spacing: 4) {
                            Text("Attempts")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("1", text: $route.attempts)
                                .keyboardType(.numberPad)
                                .frame(width: 30)
                        }
                    }
                    .font(.caption)
                    TextField("Notes", text: $route.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .onDelete { routes.remove(atOffsets: $0) }

            Button { routes.append(RouteEntry()) } label: {
                Label("Add Route", systemImage: "plus.circle")
            }
        }
    }

    private var yogaSection: some View {
        Section("Yoga Details") {
            TextField("Style (e.g. Vinyasa 2, Yin)", text: $style)
            TextField("Instructor", text: $instructor)

            ForEach($poses) { $pose in
                TextField("Pose name", text: $pose.name)
            }
            .onDelete { poses.remove(atOffsets: $0) }

            Button { poses.append(PoseEntry()) } label: {
                Label("Add Pose", systemImage: "plus.circle")
            }
        }
    }

    // MARK: - Save

    private func save() {
        isSaving = true
        errorMessage = nil

        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let dateString = fmt.string(from: date)

        let now = ISO8601DateFormatter().string(from: Date())
        let session = Session(
            id: nil,
            date: dateString,
            sport: sport.dbValue,
            durationMinutes: Int(durationMinutes),
            notes: notes,
            feel: feel == 0 ? nil : feel,
            source: "manual",
            imagePath: nil,
            createdAt: now,
            updatedAt: nil
        )

        let detail: SessionDetail
        switch sport {
        case .running:
            let run = RunningSession(
                id: nil, sessionId: 0,
                distanceMiles: Double(distanceMiles),
                time: runTime.isEmpty ? nil : runTime,
                pace: pace.isEmpty ? nil : pace,
                notes: nil
            )
            detail = .running(run)

        case .lifting:
            let wt = WeightTrainingSession(
                id: nil, sessionId: 0,
                target: target.isEmpty ? nil : target,
                notes: nil
            )
            let exList = exercises.filter { !$0.name.isEmpty }.map { ex in
                Exercise(
                    id: nil, wtTrainingSessionId: 0,
                    name: ex.name,
                    sets: Int(ex.sets),
                    reps: Int(ex.reps),
                    weight: Double(ex.weight),
                    weightUnit: ex.weightUnit.isEmpty ? nil : ex.weightUnit,
                    notes: ex.notes.isEmpty ? nil : ex.notes
                )
            }
            detail = .weightTraining(wt, exList)

        case .climbing:
            let climb = ClimbingSession(
                id: nil, sessionId: 0,
                type: climbType.isEmpty ? nil : climbType
            )
            let routeList = routes.filter { !$0.name.isEmpty }.map { r in
                ClimbingRoute(
                    id: nil, climbingSessionId: 0,
                    name: r.name,
                    sent: r.sent ? 1 : 0,
                    attempts: Int(r.attempts) ?? 1,
                    grade: r.grade.isEmpty ? nil : r.grade,
                    notes: r.notes.isEmpty ? nil : r.notes
                )
            }
            detail = .climbing(climb, routeList)

        case .yoga:
            let yoga = YogaSession(
                id: nil, sessionId: 0,
                style: style.isEmpty ? nil : style,
                instructor: instructor.isEmpty ? nil : instructor,
                notes: nil
            )
            let poseList = poses.filter { !$0.name.isEmpty }.map { p in
                YogaPose(id: nil, yogaSessionId: 0, name: p.name)
            }
            detail = .yoga(yoga, poseList)
        }

        do {
            try SessionRepository.shared.save(session: session, detail: detail)
            dismiss()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            isSaving = false
        }
    }
}

#Preview {
    ManualEntryView()
}
