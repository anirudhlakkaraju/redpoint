import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("calendar", "Log"),
        ("chart.pie", "Stats"),
        ("list.bullet", "Activities"),
        ("ellipsis", "More"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.primary.opacity(0.15))
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { index in
                    Button {
                        selectedTab = index
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[index].icon)
                                .font(.system(size: 20))
                            Text(tabs[index].label)
                                .font(.caption2)
                        }
                        .foregroundStyle(
                            selectedTab == index ? .primary : Color.primary.opacity(0.4)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
}
