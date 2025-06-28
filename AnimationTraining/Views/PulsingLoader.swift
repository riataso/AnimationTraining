import SwiftUI

struct PulsingLoader: View {
    @State private var isPulsing = false

        var body: some View {
            VStack(spacing: 16) {
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
                    .scaleEffect(isPulsing ? 1.2 : 0.8)
                    .opacity(isPulsing ? 0.6 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                Text("読み込み中...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .onAppear {
                isPulsing = true
            }
        }
}

#Preview {
    PulsingLoader()
}
