//

import SwiftUI

struct NotWithAnimation: View {
    @State private var scale: CGFloat = 1.0

        var body: some View {
            VStack(spacing: 40) {
                Text("ボタンを押してみてください")

                Button("押してね") {
                    // .animationでは以下の動作は期待通りに動かない
                    scale = 0.9
                    scale = 1.0  // 即座に1.0に戻すため、アニメーションが発生しない

                    print("ボタンが押されました")
                }
                .scaleEffect(scale)
                .animation(.easeInOut(duration: 0.2), value: scale)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
}

#Preview {
    NotWithAnimation()
}
