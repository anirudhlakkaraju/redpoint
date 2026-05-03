import SwiftUI

struct ActivitiesView: View {
    var body: some View {
        ContentUnavailableView("Activities", systemImage: "list.bullet",
                               description: Text("Coming soon"))
    }
}

#Preview {
    ActivitiesView()
}
