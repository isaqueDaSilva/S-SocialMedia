//
//  View+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

extension View {
    func textFieldDefaultStyle() -> some View {
        self
            .font(.subheadline)
            .padding(12)
            .background(Color(uiColor: .systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(height: 44)
    }
}
