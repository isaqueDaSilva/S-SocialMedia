//
//  Image+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import SwiftUI

extension Image {
    init(uiImage: UIImage, size: CGSize) {
        let resizedImage = uiImage.resizer(with: size)
        
        self.init(uiImage: resizedImage)
    }
    
    init(resource: ImageResource, size: CGSize) {
        let uiImage = UIImage(resource: resource)
    
        self.init(uiImage: uiImage, size: size)
    }
}
