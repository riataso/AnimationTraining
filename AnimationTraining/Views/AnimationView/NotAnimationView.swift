//

import SwiftUI

struct NotAnimationView: View {
    @State private var isAnimated = false

    var body: some View {
        Circle()
            .fill(isAnimated ? Color.blue : Color.red)
            .frame(width: isAnimated ? 200 : 100, height: isAnimated ? 200 : 100)
            .onTapGesture {
                isAnimated.toggle()
            }
    }
}

#Preview {
    NotAnimationView()
}
