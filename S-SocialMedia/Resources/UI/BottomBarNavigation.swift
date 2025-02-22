//
//  SecondaryLabel.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct SecondaryLabel: View {
    let primaryText: String
    let secondaryText: String
    
    
    var body: some View {
        HStack(spacing: 5) {
            Text(primaryText)
            Text(secondaryText)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .foregroundStyle(.primary)
    }
}

#Preview {
    SecondaryLabel(
        primaryText: "Don't have an account?",
        secondaryText: "Sign Up"
    )
}
