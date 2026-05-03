import SwiftUI

struct MoreView: View {
    var body: some View {
        ContentUnavailableView("More", systemImage: "ellipsis",
                               description: Text("Coming soon"))
    }
}

#Preview {
    MoreView()
}
