/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model content for the about me module.
*/

import SwiftUI
import AVFoundation

/// Custom video player view.
struct CustomVideoPlayer: UIViewRepresentable {
    let videoURL: URL

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoURL: videoURL)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

/// UIView container.
class PlayerUIView: UIView {
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    init(videoURL: URL) {
        super.init(frame: .zero)
        setupPlayer(videoURL: videoURL)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer(videoURL: URL) {
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = bounds
        layer.addSublayer(playerLayer!)
        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

/// The model content for the about me module.
struct AboutMe: View {
    @Environment(ViewModel.self) private var model

    private let videoURL = Bundle.main.url(forResource: "SelfIntroduction", withExtension: "mp4")!

    var body: some View {
        CustomVideoPlayer(videoURL: videoURL)
            .placementGestures(
                initialPosition: Point3D([475, -1200.0, -1200.0])
            )
            .onDisappear {
                model.isShowingAboutMe = false
            }
    }
}
