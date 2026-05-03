import SwiftUI

struct CorrectionView: View {
    let image: UIImage

    var body: some View {
        Text("Correction — review parsed log here")
            .navigationTitle("Review Log")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CorrectionView(image: UIImage())
    }
}
