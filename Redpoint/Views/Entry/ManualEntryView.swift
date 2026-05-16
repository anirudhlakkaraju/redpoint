import SwiftUI

// MARK: - Active field

enum ActiveField: Equatable {
    case date, sport, duration
    case target, climbType
    case exercise(UUID?)
    case route(UUID?)
    case pose(UUID?)
    case none
}

// MARK: - View

struct ManualEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var suggestions = SuggestionsStore()

    @State var activeField: ActiveField = .sport

    // Common
    @State var date = Date()
    @State var selectedSport: Sport? = nil
    @State var durationMinutes = 0
    @State var notes = ""
    @State var feel = 0

    // Running
    @State var distanceMiles = ""
    @State var runTime = ""
    @State var pace = ""

    // Weight training
    @State var target = ""
    @State var exercises: [ExerciseEntry] = []
    @State var draftEx = ExerciseEntry()
    @State var draftSet = SetEntry()
    @State var editingExId: UUID? = nil

    // Climbing
    @State var climbType = ""
    @State var routes: [RouteEntry] = []
    @State var draftRoute = RouteEntry()
    @State var editingRouteId: UUID? = nil

    // Yoga
    @State var yogaStyle = ""
    @State var instructor = ""
    @State var poses: [PoseEntry] = []
    @State var draftPose = PoseEntry()
    @State var editingPoseId: UUID? = nil

    @State var isSaving = false
    @State var errorMessage: String? = nil

    var showsBottomPanel: Bool {
        activeField != .none
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Top: field rows ──────────────────────────
                ScrollView {
                    VStack(spacing: 0) {
                        fieldRow(
                            "Date",
                            value: date.formatted(
                                .dateTime.weekday(.abbreviated).month(.abbreviated).day().year()),
                            field: .date)

                        fieldRow(
                            "Sport",
                            value: selectedSport?.rawValue ?? "",
                            placeholder: "Select sport",
                            field: .sport)

                        if selectedSport != nil {

                            switch selectedSport {
                            case .running: runningRows
                            case .lifting: weightTrainingRows
                            case .climbing: climbingRows
                            case .yoga: yogaRows
                            case .none: EmptyView()
                            }
                        }
                    }
                }

                // ── Divider ───────────────────────────────────
                if showsBottomPanel {
                    Rectangle()
                        .fill(Color.primary.opacity(0.12))
                        .frame(height: 1)
                }

                // ── Bottom panel ──────────────────────────────
                if showsBottomPanel {
                    bottomPanel
                        .frame(minHeight: UIScreen.main.bounds.height * 0.45)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: activeField)
            .navigationTitle("Log Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(selectedSport == nil || isSaving)
                }
            }
            .overlay(alignment: .bottom) {
                if let msg = errorMessage {
                    Text(msg)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                errorMessage = nil
                            }
                        }
                }
            }
        }
    }

    // MARK: - Bottom panel

    @ViewBuilder
    var bottomPanel: some View {
        switch activeField {
        case .date:
            CalendarDatePicker(date: $date)
                .frame(height: UIScreen.main.bounds.height * 0.45)

        case .sport:
            VStack(spacing: 0) {
                SportsPickerGrid(selection: $selectedSport) { sport in
                    selectedSport = sport
                    activeField = sport == .running ? .runTime : .duration
                }
            }

        case .duration:
            HStack(spacing: 0) {
                Picker("", selection: $durationMinutes) {
                    ForEach(Array(stride(from: 0, through: 300, by: 5)), id: \.self) { min in
                        Text(min == 0 ? "—" : "\(min) min").tag(min)
                    }
                }
                .pickerStyle(.wheel)
            }
            .padding(.horizontal)

        case .target:
            let targets = ["Push", "Pull", "Legs", "Arms", "Shoulders", "Full Body", "Other"]
            let targetCols = 3
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: targetCols),
                spacing: 0
            ) {
                ForEach(Array(targets.enumerated()), id: \.element) { idx, t in
                    Button {
                        target = t
                        activeField = .none
                    } label: {
                        Text(t)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 22)
                            .background(target == t ? Color.red.opacity(0.12) : Color.clear)
                            .foregroundStyle(target == t ? Color.red : Color.primary)
                            .overlay(alignment: .bottom) {
                                if idx < targets.count - targetCols {
                                    Rectangle().fill(Color.primary.opacity(0.12)).frame(height: 1)
                                }
                            }
                            .overlay(alignment: .trailing) {
                                if idx % targetCols != targetCols - 1 {
                                    Rectangle().fill(Color.primary.opacity(0.12)).frame(width: 1)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }

        case .climbType:
            let climbTypes = ["Boulder", "Route", "Mixed"]
            HStack(spacing: 0) {
                ForEach(Array(climbTypes.enumerated()), id: \.element) { idx, t in
                    Button {
                        climbType = t
                        activeField = .none
                    } label: {
                        Text(t)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 28)
                            .background(climbType == t ? Color.red.opacity(0.12) : Color.clear)
                            .foregroundStyle(climbType == t ? Color.red : Color.primary)
                            .overlay(alignment: .trailing) {
                                if idx < climbTypes.count - 1 {
                                    Rectangle().fill(Color.primary.opacity(0.12)).frame(width: 1)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }

        case .exercise:
            exercisePanel

        case .route:
            routePanel

        case .pose:
            posePanel

        case .none:
            EmptyView()
        }
    }

    // MARK: - Helpers

    func inlineTextRow(
        _ label: String, text: Binding<String>, placeholder: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        HStack(spacing: 16) {
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 72, alignment: .leading)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .onTapGesture { activeField = .none }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(alignment: .bottom) {
            Rectangle().fill(Color.primary.opacity(0.1)).frame(height: 1)
        }
    }

    func addRowButton(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill").foregroundStyle(.red)
                Text(label).foregroundStyle(.red)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .bottom) {
                Rectangle().fill(Color.primary.opacity(0.1)).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    func suggestionsRow(
        for query: String, pool: [String], onSelect: @escaping (String) -> Void
    ) -> some View {
        let filtered = pool.filter { query.isEmpty || $0.localizedCaseInsensitiveContains(query) }
        return Group {
            if !filtered.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filtered, id: \.self) { name in
                            Button(name) { onSelect(name) }
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(.tertiarySystemBackground))
                                .cornerRadius(12)
                                .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    func numericField(_ placeholder: String, text: Binding<String>, decimal: Bool = false)
        -> some View
    {
        TextField(placeholder, text: text)
            .keyboardType(decimal ? .decimalPad : .numberPad)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
    }

    func commitButton(label: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(disabled ? Color.secondary.opacity(0.3) : Color.red)
                .foregroundStyle(.white)
                .cornerRadius(8)
        }
        .disabled(disabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    // MARK: - Save

    func save() {
        guard let sport = selectedSport else { return }
        isSaving = true

        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let now = ISO8601DateFormatter().string(from: Date())

        let session = Session(
            id: nil,
            date: fmt.string(from: date),
            sport: sport.dbValue,
            durationMinutes: durationMinutes == 0 ? nil : durationMinutes,
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
            detail = .running(
                RunningSession(
                    id: nil, sessionId: 0,
                    distanceMiles: Double(distanceMiles),
                    time: runTime.isEmpty ? nil : runTime,
                    pace: pace.isEmpty ? nil : pace,
                    notes: nil
                ))
        case .lifting:
            let wt = WeightTrainingSession(
                id: nil, sessionId: 0,
                target: target.isEmpty ? nil : target, notes: nil)
            let exList: [(ExerciseEntry)] = exercises.filter { !$0.name.isEmpty }
            detail = .weightTraining(wt, exList)
        case .climbing:
            let c = ClimbingSession(
                id: nil, sessionId: 0, type: climbType.isEmpty ? nil : climbType)
            let rList = routes.filter { !$0.name.isEmpty }.map {
                ClimbingRoute(
                    id: nil, climbingSessionId: 0,
                    name: $0.name, sent: $0.sent ? 1 : 0,
                    attempts: Int($0.attempts) ?? 1,
                    grade: $0.grade.isEmpty ? nil : $0.grade, notes: nil)
            }
            detail = .climbing(c, rList)
        case .yoga:
            let y = YogaSession(
                id: nil, sessionId: 0,
                style: yogaStyle.isEmpty ? nil : yogaStyle,
                instructor: instructor.isEmpty ? nil : instructor, notes: nil)
            let pList = poses.filter { !$0.name.isEmpty }.map {
                YogaPose(id: nil, yogaSessionId: 0, name: $0.name)
            }
            detail = .yoga(y, pList)
        }

        do {
            try SessionRepository.shared.save(session: session, detail: detail)
            dismiss()
        } catch {
            errorMessage = "Save failed: \(error.localizedDescription)"
            isSaving = false
        }
    }
}

#Preview {
    ManualEntryView()
}
