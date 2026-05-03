import SwiftUI

struct SessionCardView: View {
    let session: MockSession

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: session.sport.icon)
                .font(.title3)
                .frame(width: 28)
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(session.sport.rawValue) · \(session.keyMetric)")
                    .font(.subheadline.weight(.medium))
                if !session.notes.isEmpty {
                    Text(session.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    SessionCardView(session: MockData.sessions[0])
        .padding()
}
