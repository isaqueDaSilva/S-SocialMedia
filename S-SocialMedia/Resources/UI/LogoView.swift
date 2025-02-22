//
//  LogoView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image(resource: .logo, size: .midSizePicture)
            .resizable()
            .scaledToFit()
            .frame(
                width: CGSize.midSizePicture.width,
                height: CGSize.midSizePicture.height
            )
    }
}

#Preview {
    LogoView()
}
