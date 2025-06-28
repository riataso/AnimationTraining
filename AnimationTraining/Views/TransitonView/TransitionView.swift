import SwiftUI

struct トランジション: View {
    @State private var showCircle = false

        var body: some View {
            VStack(spacing: 40) {
                // 円の表示エリア
                if showCircle {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                        .transition(.scale)
                }

                // 切り替えボタン
                Button(showCircle ? "非表示" : "表示") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showCircle.toggle()
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
}

#Preview {
    トランジション()
}
