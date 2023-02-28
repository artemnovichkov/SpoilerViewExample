//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

final class EmitterView: UIView {

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

    func makeUIView(context: Context) -> EmitterView {
        let emitterView = EmitterView()

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

        emitterView.layer.emitterShape = .rectangle
        emitterView.layer.emitterCells = [emitterCell]

        return emitterView
    }

    func updateUIView(_ uiView: EmitterView, context: Context) {
        uiView.layer.emitterPosition = .init(x: size.width / 2,
                                             y: size.height / 2)
        uiView.layer.emitterSize = size
    }
}

struct SpoilerModifier: ViewModifier {

    let isOn: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isOn {
                    GeometryReader { proxy in
                        SpoilerView(size: proxy.size)
                    }
                }
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
