//
//  UserProfilePicture.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct UserProfilePicture: View {
    let uiImage: UIImage?
    let size: CGSize
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage, size: size)
                    .resizable()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: size.width, height: size.height)
    }

    init(uiImage: UIImage? = nil, size: CGSize = .smallSizePicture) {
        self.uiImage = uiImage
        self.size = size
    }
}

#Preview {
    UserProfilePicture(uiImage: .logo)
}
