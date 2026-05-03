import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: Int = 0
    @State private var showCamera: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                DateTabView()
                    .tabItem { Label("Log", systemImage: "calendar") }
                    .tag(0)
                StatsView()
                    .tabItem { Label("Stats", systemImage: "chart.pie") }
                    .tag(1)
                ActivitiesView()
                    .tabItem { Label("Activities", systemImage: "list.bullet") }
                    .tag(2)
                MoreView()
                    .tabItem { Label("More", systemImage: "ellipsis") }
                    .tag(3)
            }

            if selectedTab == 0 {
                Button {
                    showCamera = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 90)
                .fullScreenCover(isPresented: $showCamera) {
                    NavigationStack {
                        CameraView()
                    }
                }
            }
        }
    }
}

#Preview {
    RootTabView()
}
