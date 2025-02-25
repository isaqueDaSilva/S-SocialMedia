//
//  View+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

extension View {
    func textFieldDefaultStyle(
        backgroundColor: Color = .init(uiColor: .systemGray6),
        padding: CGFloat = 12
    ) -> some View {
        self
            .font(.subheadline)
            .padding(padding)
            .materialActiveAppearance(.matchWindow)
            .background(.thinMaterial)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
