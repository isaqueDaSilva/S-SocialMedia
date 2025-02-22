//
//  ImageSetter.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI
import PhotosUI
import Observation
import os.log

@Observable
@MainActor
final class ImageSetter {
    @ObservationIgnored
    private let logger = Logger(
        subsystem: "com.isaqueDaSilva.Bookworm",
        category: "ImageSetter"
    )
    
    var uimage: UIImage? = nil
    var uiImageData: Data? = nil
    var pickerItemSelect: PhotosPickerItem? = nil {
        didSet {
            if let pickerItemSelect {
                getImage(pickerItemSelect)
            }
        }
    }
    
    private func getImage(_ pickerItemSelected: PhotosPickerItem) {
        Task {
            if let pickerItemSelect,
               let data = try? await pickerItemSelect.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.uiImageData = data
                        self.uimage = image
                        self.logger.info("A new image was setted with success.")
                    }
                }
            }
        }
    }
    
    init() { }
    
    init(coverImage: UIImage?, coverImageData: Data?) {
        self.uimage = coverImage
        self.uiImageData = coverImageData
    }
}
