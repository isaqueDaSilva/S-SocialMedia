//
//  CGSize+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import Foundation

extension CGSize {
    func aspectToFit(_ size: CGSize) -> CGSize {
        let scaleX = size.width / self.width
        let scaleY = size.height / self.height
        
        let aspectRatio = min(scaleX, scaleY)
        
        let width = aspectRatio * self.width
        let height = aspectRatio * self.height
        
        return .init(width: width, height: height)
    }
    
    static let highSizePicture: Self = .init(width: 175, height: 175)
    static let midSizePicture: Self = .init(width: 100, height: 100)
}
