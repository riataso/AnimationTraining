import SwiftUI

struct AppleCardAnimationView: View {
    @Namespace var namespace
    @State private var showDetail = false

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()

            if showDetail {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black)
                    .matchedGeometryEffect(id: "card", in: namespace)
                    .frame(width: 300, height: 400)
                    .overlay(
                        VStack {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Apple")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 8)
                        }
                    )
                    .shadow(radius: 10)
                    .onTapGesture { withAnimation(.spring()) { showDetail.toggle() } }
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black)
                    .matchedGeometryEffect(id: "card", in: namespace)
                    .frame(width: 100, height: 150)
                    .overlay(
                        Image(systemName: "apple.logo")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    )
                    .shadow(radius: 5)
                    .onTapGesture { withAnimation(.spring()) { showDetail.toggle() } }
            }
        }
    }


}

#Preview {
    AppleCardAnimationView()
}
