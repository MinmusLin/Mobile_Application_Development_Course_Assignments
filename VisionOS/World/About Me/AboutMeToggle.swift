/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A toggle that activates or deactivates the about me scene.
*/

import SwiftUI

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

#Preview {
    AboutMeToggle()
        .environment(ViewModel())
}
