import SwiftUI

// MARK: - Draft

struct PoseEntry: Identifiable {
    var id = UUID()
    var name = ""
}

// MARK: - Extension

extension ManualEntryView {

    // MARK: - Yoga rows

    @ViewBuilder
    var yogaRows: some View {
        inlineTextRow("Style", text: $yogaStyle, placeholder: "Vinyasa, Yin...")
        inlineTextRow("Instructor", text: $instructor, placeholder: "Name")

        ForEach(poses) { pose in
            poseListRow(pose)
        }

        addRowButton(label: "Add Pose") {
            draftPose = PoseEntry()
            editingPoseId = nil
            activeField = .pose(nil)
        }
    }

    // MARK: - Pose list row

    private func poseListRow(_ p: PoseEntry) -> some View {
        Button {
            draftPose = p
            editingPoseId = p.id
            activeField = .pose(p.id)
        } label: {
            HStack(spacing: 16) {
                Text("Pose").foregroundStyle(.secondary).frame(width: 72, alignment: .leading)
                Text(p.name.isEmpty ? "Tap to name" : p.name)
                    .foregroundStyle(p.name.isEmpty ? Color.primary.opacity(0.4) : .primary)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(alignment: .bottom) {
                Rectangle().fill(Color.primary.opacity(0.1)).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Pose panel

    var posePanel: some View {
        VStack(spacing: 10) {
            suggestionsRow(for: draftPose.name, pool: suggestions.poseNames) { draftPose.name = $0 }

            TextField("Pose name", text: $draftPose.name)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal, 16)

            commitButton(
                label: editingPoseId == nil ? "Add Pose" : "Update",
                disabled: draftPose.name.isEmpty
            ) {
                commitPose()
            }
        }
        .padding(.vertical, 10)
    }

    // MARK: - Commit

    private func commitPose() {
        suggestions.addPose(draftPose.name)
        if let id = editingPoseId, let idx = poses.firstIndex(where: { $0.id == id }) {
            poses[idx] = draftPose
        } else {
            poses.append(draftPose)
        }
        draftPose = PoseEntry()
        editingPoseId = nil
        activeField = .pose(nil)
    }
}
