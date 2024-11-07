# VisionOS

## 项目名称

VisionOS | 个人介绍应用

## 项目演示

导航演示：**首页**

![](assets/NavigationDemonstration.gif)

生命中的一天：**地球**

![](assets/GlobeDemonstration.gif)

我们的近邻：**轨道中的天体**

![](assets/OrbitDemonstration.gif)

遨游太空：**太阳系**

![](assets/SolarSystemDemonstration.gif)

关于我：**林继申**

![](assets/AboutMeDemonstration.gif)

## 项目 MVVM（Model-View-ViewModel）设计模式架构

World 项目使用了 MVVM（Model-View-ViewModel）设计模式。

### Model（模型）

在 MVVM 设计模式中，Model 层负责存储和管理应用的数据，而 `Module` 枚举正是描述了应用程序中各个模块的数据和信息。

* **数据定义与存储**：`Module` 枚举定义了应用中的各个模块（如 `globe`、`orbit`、`solar`、`about`），并为每个模块提供了与之相关的元数据，比如标题（`heading`）、描述（`abstract`）、操作文案（`callToAction`）等。这些数据直接被视图使用，因此它们属于 Model 层。
* **静态与动态数据**：`Module` 主要存储静态数据，例如模块的标题、描述和调用信息。这些数据虽然不会频繁变化，但它们是应用核心的内容来源。与动态状态（如 ViewModel 中的状态变量）不同，它更关注模块本身的结构化信息。
* **业务逻辑中的数据角色**：在 MVVM 模式中，ViewModel 是视图与模型之间的桥梁，负责管理和操作模型中的数据。而 `Module` 中的静态信息可以通过 ViewModel 提供给视图，视图最终使用这些数据来渲染 UI。

虽然 `Module` 是一个枚举，但它本质上是应用程序的 Model 层数据的一部分，用于定义每个模块的静态信息。这些信息被 ViewModel 访问并传递给视图，确保应用数据与 UI 保持同步。

Model 层涉及的修改如下：

* **`Module.swift` 中的修改**：在 `Module` 枚举中新增了 `about` 模块，并为其提供了一系列属性，包括 `eyebrow`、`heading`、`abstract`、`overview` 和 `callToAction`，这些属性描述了模块的标题、描述和用户可以采取的操作。这些修改扩展了应用的模块体系，使“About Me”成为可供展示和交互的模块。
* **`ModuleCard.swift` 中的修改**：添加了一行代码 `ModuleCard(module: .about)`，将“About Me”模块集成到模块卡片视图中。此修改确保用户可以在模块卡片列表中看到“About Me”模块，并与之交互。
* **`ModuleDetail.swift` 中的修改**：在 `ModuleDetail` 视图中，为 `about` 模块添加了支持，具体表现为在该模块被选中时显示 `AboutMeToggle`。此外，还在模块详情扩展方法中增加了 `AboutMeModule` 的逻辑，使“About Me”模块的详细内容可以被渲染。
* **`Modules.swift` 中的修改**：在 `Modules` 视图中扩展了模块关闭逻辑，通过添加 `model.isShowingAboutMe`，确保“About Me”模块在其状态为关闭时可以被正确地退出沉浸式空间。这一修改与其他模块的关闭逻辑保持一致，确保沉浸式体验的流畅性和资源管理的有效性。

### View（视图）

在 View 层添加了一个模块化的“About Me”功能：

* `AboutMe` 显示视频内容。
* `AboutMeModule` 显示用户标识图片。
* `AboutMeToggle` 提供切换逻辑。

这种模块化和解耦设计体现了 MVVM 模式，视图（View）部分专注于渲染和用户交互，所有状态和逻辑处理依赖于 `ViewModel`。

`CustomVideoPlayer` 是一个 SwiftUI 视图，它将 UIKit 的 `AVPlayer` 封装在 SwiftUI 环境中，用于播放视频。通过使用 `UIViewRepresentable`，该视图将视频播放器作为一个 UIView 添加到 SwiftUI 视图中。

```swift
/// Custom video player view.
struct CustomVideoPlayer: UIViewRepresentable {
    let videoURL: URL

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoURL: videoURL)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
```

`PlayerUIView` 是一个自定义的 UIView，直接处理视频播放器层（`AVPlayerLayer`），并在初始化时设置播放器和自动播放视频，同时确保视频层始终适配视图的动态布局，使视频内容始终以合适的比例显示。

```swift
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
```

`AboutMe` 视图利用 `CustomVideoPlayer` 播放自我介绍视频，并通过 `placementGestures` 方法在 3D 空间中设置视频的初始位置，在视图消失时会自动关闭该模块以优化资源和用户体验。

```swift
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
```

`AboutMeModule` 是一个展示用户标识照片的 SwiftUI 视图，它通过 `GeometryReader` 使图像根据父视图的尺寸进行适配和缩放，确保图像居中显示且在不同设备上拥有良好的自适应效果。

```swift
/// The module detail content that's specific to the about me module.
struct AboutMeModule: View {
    var body: some View {
        GeometryReader { geometry in
            Image("IdentificationPhoto")
                .resizable()
                .scaledToFit()
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.8
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
```

`AboutMeToggle` 提供了一个用于激活和关闭“About Me”场景的开关，通过监控和修改 `ViewModel` 的 `isShowingAboutMe` 状态，以异步方式在必要时打开或关闭沉浸式空间，从而在视觉上和逻辑上实现视图的切换和资源管理。

```swift
/// A toggle that activates or deactivates the about me scene.
struct AboutMeToggle: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        @Bindable var model = model

        Toggle(Module.about.callToAction, isOn: $model.isShowingAboutMe)
            .onChange(of: model.isShowingAboutMe) { _, isShowing in
                Task {
                    if isShowing {
                        await openImmersiveSpace(id: Module.about.name)
                    } else {
                        await dismissImmersiveSpace()
                    }
                }
            }
            .toggleStyle(.button)
    }
}
```

### ViewModel（视图模型）

`ViewModel` 是一个应用程序的核心数据存储类，负责管理视图的状态和配置数据。它遵循 `@Observable` 属性包装器，使其属性在发生更改时能够自动通知视图更新。这种设计方式适用于 MVVM 模式中的 ViewModel 层，确保视图能够以响应式的方式与数据同步。

* **导航部分（Navigation）**：管理应用程序的导航路径、标题文本以及标题显示状态。`finalTitle` 是应用程序的主标题，默认显示为“Hello World”。
* **地球展示部分（Globe）**：控制是否显示旋转地球模型，并提供地球的配置和倾斜角度设置。`globeEarth` 和 `globeTilt` 代表地球的基本配置和倾斜角。
* **轨道展示部分（Orbit）**：处理地球、卫星和月球在轨道模式中的显示和配置状态，允许用户观察这些天体在轨道中的运动。
* **太阳系展示部分（Solar System）**：管理太阳系视图的状态和各天体的配置，包括地球、卫星、月球及太阳的位置。`solarSunDistance` 和 `solarSunPosition` 定义太阳的位置及其相对于地球的距离和角度。
* **关于我展示部分（About Me）**：用于显示“About Me”部分的状态，通过 `isShowingAboutMe` 控制模块是否展示。

```swift
/// The data that the app uses to configure its views.
@Observable
class ViewModel {

    // MARK: - Navigation
    var navigationPath: [Module] = []
    var titleText: String = ""
    var isTitleFinished: Bool = false
    var finalTitle: String = String(localized: "Hello World", comment: "The title of the app.")

    // MARK: - Globe
    var isShowingGlobe: Bool = false
    var globeEarth: EarthEntity.Configuration = .globeEarthDefault
    var isGlobeRotating: Bool = false
    var globeTilt: GlobeTilt = .none

    // MARK: - Orbit
    var isShowingOrbit: Bool = false
    var orbitEarth: EarthEntity.Configuration = .orbitEarthDefault
    var orbitSatellite: SatelliteEntity.Configuration = .orbitSatelliteDefault
    var orbitMoon: SatelliteEntity.Configuration = .orbitMoonDefault

    // MARK: - Solar System
    var isShowingSolar: Bool = false
    var solarEarth: EarthEntity.Configuration = .solarEarthDefault
    var solarSatellite: SatelliteEntity.Configuration = .solarTelescopeDefault
    var solarMoon: SatelliteEntity.Configuration = .solarMoonDefault

    var solarSunDistance: Double = 700
    var solarSunPosition: SIMD3<Float> {
        [Float(solarSunDistance * sin(solarEarth.sunAngle.radians)),
         0,
         Float(solarSunDistance * cos(solarEarth.sunAngle.radians))]
    }

    // MARK: - About Me
    var isShowingAboutMe: Bool = false
}
```

`ViewModel` 通过集中管理应用程序的所有核心数据，为多个视图组件提供状态支持，并在数据发生变化时触发视图更新，从而实现数据驱动的用户界面。

## 文档更新日期

2024年11月7日