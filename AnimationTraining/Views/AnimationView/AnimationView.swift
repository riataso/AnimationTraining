import SwiftUI

struct 暗黙的アニメーション: View {
    @State private var isAnimated = false

    var body: some View {
        Circle()
            .fill(isAnimated ? Color.blue : Color.red)
            .frame(width: isAnimated ? 200 : 100, height: isAnimated ? 200 : 100)
            // animationモディファイアでisAnimatedの変化を監視し、
            // ゆっくり始まってゆっくり終わる滑らかなアニメーション（0.5秒）を適用
            .animation(.easeInOut(duration: 0.5), value: isAnimated)
            .onTapGesture {
                isAnimated.toggle()
            }
    }
}

#Preview {
    暗黙的アニメーション()
}
