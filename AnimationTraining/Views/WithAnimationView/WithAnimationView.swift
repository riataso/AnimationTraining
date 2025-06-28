import SwiftUI

struct 明示的アニメーション: View {
    @State private var scale: CGFloat = 1.0

        var body: some View {
            VStack(spacing: 40) {
                Text("ボタンを押してみてください")

                Button("押してね") {
                    // 第1段階：ボタンを縮めるアニメーション（0.1秒、ゆっくり始まる）
                    withAnimation(.easeIn(duration: 0.1)) {
                        scale = 0.9
                    } completion: {
                        // 第1段階完了後に実行：元のサイズに戻すアニメーション（0.1秒、ゆっくり終わる）
                        withAnimation(.easeOut(duration: 0.1)) {
                            scale = 1.0
                        }
                    }
                }
                .scaleEffect(scale)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
}

#Preview {
    明示的アニメーション()
}
