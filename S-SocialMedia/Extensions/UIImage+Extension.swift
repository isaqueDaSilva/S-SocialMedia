//
//  UIImage+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

extension UIImage {
    func resizer(with newSize: CGSize) -> UIImage {
        let aspectSize = self.size.aspectToFit(size)
        
        let renderer = UIGraphicsImageRenderer(size: aspectSize)
        
        let resizedImage = renderer.image { context in
            self.draw(in: .init(origin: .zero, size: aspectSize))
        }
        
        return resizedImage
    }
}

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
