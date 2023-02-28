//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

final class SpoilerUIView: UIView {

    override class var layerClass: AnyClass {
        CAEmitterLayer.self
    }

    override var layer: CAEmitterLayer {
        super.layer as! CAEmitterLayer
    }
}

/// Based on [InvisibleInkDustNode.swift](https://github.com/TelegramMessenger/Telegram-iOS/blob/930d1fcc46e39830e6d590986a6a838c3ff49e27/submodules/InvisibleInkDustNode/Sources/InvisibleInkDustNode.swift#L97-L109)
struct SpoilerView: UIViewRepresentable {

    let size: CGSize

    func makeUIView(context: Context) -> SpoilerUIView {
        let view = SpoilerUIView()

        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "textSpeckle_Normal")?.cgImage
        emitterCell.color = UIColor.black.cgColor
        emitterCell.contentsScale = 1.8
        emitterCell.emissionRange = .pi * 2
        emitterCell.lifetime = 1
        emitterCell.scale = 0.5
        emitterCell.velocityRange = 20
        emitterCell.alphaRange = 1
        emitterCell.birthRate = 4000

        view.layer.emitterShape = .rectangle
        view.layer.emitterCells = [emitterCell]

        return view
    }

    func updateUIView(_ uiView: SpoilerUIView, context: Context) {
        uiView.layer.emitterPosition = .init(x: size.width / 2,
                                             y: size.height / 2)
        uiView.layer.emitterSize = size
    }
}

struct SpoilerModifier: ViewModifier {

    let isOn: Bool
    @State private var size: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .readSize { size in
                self.size = size
            }
            .overlay {
                SpoilerView(size: size)
                    .opacity(isOn ? 1 : 0)
            }
    }
}

extension View {

    func spoiler(isOn: Binding<Bool>) -> some View {
        self
            .opacity(isOn.wrappedValue ? 0 : 1)
            .modifier(SpoilerModifier(isOn: isOn.wrappedValue))
            .animation(.default, value: isOn.wrappedValue)
            .onTapGesture {
                isOn.wrappedValue = !isOn.wrappedValue
            }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
