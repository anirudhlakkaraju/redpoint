import SwiftUI

extension ManualEntryView {

    // MARK: - Field rows

    func fieldRow(
        _ label: String, value: String, placeholder: String = "", field: ActiveField
    ) -> some View {
        let isActive = activeField == field
        return Button {
            activeField = field     
        } label: {
            HStack(spacing: 16) {
                Text(label)
                    .foregroundStyle(.secondary)
                    .frame(width: 72, alignment: .leading)
                if value.isEmpty {
                    Text(placeholder).foregroundStyle(Color.primary.opacity(0.25))
                } else {
                    Text(value).foregroundStyle(.primary)
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
    }

    var durationRow: some View {
        let isActive = activeField == .duration
        let label = durationMinutes == 0 ? "" : "\(durationMinutes) min"
        return Button {
            activeField = .duration
        } label: {
            HStack(spacing: 16) {
                Text("Duration")
                    .foregroundStyle(.secondary)
                    .frame(width: 72, alignment: .leading)
                if label.isEmpty {
                    Text("Select").foregroundStyle(Color.primary.opacity(0.25))
                } else {
                    Text(label)
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
    }

    var notesRow: some View {
        HStack(spacing: 16) {
            Text("Notes")
                .foregroundStyle(.secondary)
                .frame(width: 72, alignment: .leading)
            TextField("Add notes...", text: $notes, axis: .vertical)
                .lineLimit(1...3)
                .onTapGesture { activeField = .none }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(alignment: .bottom) {
            Rectangle().fill(Color.primary.opacity(0.1)).frame(height: 1)
        }
    }
}
