import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: Int = 0
    @State private var showCamera: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                DateTabView().tag(0)
                StatsView().tag(1)
                ActivitiesView().tag(2)
                MoreView().tag(3)
            }
            .toolbar(.hidden, for: .tabBar)
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
            }

            if selectedTab == 0 {
                Button {
                    showCamera = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 80)
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
