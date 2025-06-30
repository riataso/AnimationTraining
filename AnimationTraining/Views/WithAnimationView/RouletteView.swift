import SwiftUI

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
}

// デモデータを定義
extension Restaurant {
    static let demoRestaurants: [Restaurant] = [
        Restaurant(name: "麺屋 武蔵"),
        Restaurant(name: "すき家"),
        Restaurant(name: "ガスト"),
        Restaurant(name: "サイゼリヤ"),
        Restaurant(name: "スターバックス"),
        Restaurant(name: "マクドナルド"),
        Restaurant(name: "吉野家"),
        Restaurant(name: "ココイチ"),
        Restaurant(name: "くら寿司"),
        Restaurant(name: "スシロー")
    ]
}


import SwiftUI

struct RouletteView: View {
    let restaurants: [Restaurant]
    @State private var rotation: Double = 0 //ルーレットの回転角度
    @State private var isSpinning = false   //回転中かどうか判定
    @State private var selectedIndex: Int?  //選択されたレストランのインデックス

    var body: some View {
        VStack(spacing: 40) {
            Text("今日のランチを決めよう！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            // ルーレット本体
            ZStack {
                // 背景の円
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 300)

                // ルーレットのセクション
                ForEach(0..<restaurants.count, id: \.self) { index in
                    RouletteSection(
                        restaurant: restaurants[index],
                        index: index,
                        total: restaurants.count,
                        isSelected: selectedIndex == index
                    )
                }
                .rotationEffect(.degrees(rotation))

                // 中心の円
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 5)

                // 矢印（選択インジケーター）- 下向きに修正
                Triangle()
                    .fill(Color.red)
                    .frame(width: 30, height: 40)
                    .rotationEffect(.degrees(180)) // 180度回転させて下向きに
                    .offset(y: -170)
            }
            .frame(width: 350, height: 350)

            // 選択された店舗名
            if let selectedIndex = selectedIndex {
                VStack(spacing: 10) {
                    Text("選ばれたのは...")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(restaurants[selectedIndex].name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                .transition(.scale.combined(with: .opacity))
            }

            // スピンボタン
            Button(action: spinRoulette) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text(isSpinning ? "回転中..." : "ルーレットを回す")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(isSpinning ? Color.gray : Color.blue)
                .cornerRadius(25)
            }
            .disabled(isSpinning)

            Spacer()
        }
        .padding()
    }

    /**
     ルーレットを回転させ、ランダムに選択結果を決定するメソッド

     - Parameters:
       - なし
     - Returns:なし
     */
    private func spinRoulette() {
        withAnimation(.easeOut(duration: 3)) {
            isSpinning = true
            let randomRotation = Double.random(in: 720...1440)  // 回転数の調整（2回転〜4回転）
            rotation += randomRotation

            // 3秒後に結果を表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let normalizedRotation = rotation.truncatingRemainder(dividingBy: 360)               // 回転して止まった場所を把握するための正規化値
                let sectionAngle = 360.0 / Double(restaurants.count)                                 // 1セクションあたりの角度（360 / アイテムの個数）
                selectedIndex = Int((360 - normalizedRotation) / sectionAngle) % restaurants.count
                isSpinning = false
            }
        }
    }
}

// ルーレットのセクション
struct RouletteSection: View {
    let restaurant: Restaurant
    let index: Int
    let total: Int
    let isSelected: Bool

    init(restaurant: Restaurant, index: Int, total: Int, isSelected: Bool) {
        self.restaurant = restaurant
        self.index = index
        self.total = total
        self.isSelected = isSelected
    }

    private var startAngle: Double {
        Double(index) * 360.0 / Double(total)
    }

    private var endAngle: Double {
        Double(index + 1) * 360.0 / Double(total)
    }

    private var midAngle: Double {
        (startAngle + endAngle) / 2
    }

    private var colors: [Color] = [
        .red, .blue, .green, .orange, .purple,
        .pink, .yellow, .indigo, .mint, .cyan
    ]

    var body: some View {
        ZStack {
            // セクターの描画
            SectorShape(
                startAngle: startAngle,
                endAngle: endAngle
            )
            .fill(colors[index % colors.count].opacity(isSelected ? 1.0 : 0.7))
            .overlay(
                SectorShape(
                    startAngle: startAngle,
                    endAngle: endAngle
                )
                .stroke(Color.white, lineWidth: 2)
            )

            // テキストを見やすく修正
            Text(restaurant.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 80)
                .rotationEffect(.degrees(midAngle + 90))
                .offset(
                    x: cos((midAngle - 90) * .pi / 180) * 100,
                    y: sin((midAngle - 90) * .pi / 180) * 100
                )
        }
    }
}

// セクター形状
struct SectorShape: Shape {
    let startAngle: Double
    let endAngle: Double

    /**
     扇形（セクター）の描画パスを生成するメソッド

     - Parameters:
     - rect: 描画可能な矩形領域（CGRect型）
          - 扇形を描画するための座標空間を定義
          - 中心点と半径の計算に使用
     - Returns:Path - 扇形の輪郭情報を返す
     */
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(
            center: center,                          // 円の中心：(150, 150)
            radius: radius,                          // 半径：150
            startAngle: .degrees(startAngle - 90),   // 開始角度（0度を上にする。SwiftUIは右が0度）
            endAngle: .degrees(endAngle - 90),       // 終了角度
            clockwise: false                         // 反時計回り
        )
        path.closeSubpath()

        return path
    }
}

// 三角形の矢印
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    RouletteView(restaurants: Restaurant.demoRestaurants)
}
