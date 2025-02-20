//
//  ActiveNowView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 32) {
                ForEach(0..<10) { _ in
                    ActiveNowItem()
                }
            }
            .padding(.horizontal, 15)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ActiveNowView()
}
