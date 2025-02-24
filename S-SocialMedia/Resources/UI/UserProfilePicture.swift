//
//  UserProfilePicture.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct UserProfilePicture: View {
    private let url: URL?
    private let size: CGSize
    
    var body: some View {
        Group {
            if let url {
                AsyncImage(
                    url: url,
                    scale: 1
                ) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(Color(uiColor: .systemGray))
            }
        }
        .frame(width: size.width, height: size.height)
    }
    
    init(url: URL?, size: CGSize = .smallSizePicture) {
        self.url = url
        self.size = size
    }
}

#Preview {
    VStack {
        UserProfilePicture(
            url: .init(string: "https://picsum.photos/200"),
            size: .smallSizePicture
        )
        
        UserProfilePicture(url: nil, size: .midSizePicture)
    }
    
    
}
