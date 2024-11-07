/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The module detail content that's specific to the about me module.
*/

import SwiftUI

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

#Preview {
    AboutMeModule()
        .padding()
}
