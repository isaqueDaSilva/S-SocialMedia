//
//  ChatBubble.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//

import SwiftUI

struct ChatBubble: Shape {
    private let isFromAuthenticatedUser: Bool
    
    nonisolated func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isFromAuthenticatedUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: .init(width: 16, height: 16)
        )
        
        return .init(path.cgPath)
    }
    
    init(isFromAuthenticatedUser: Bool) {
        self.isFromAuthenticatedUser = isFromAuthenticatedUser
    }
}

#Preview {
    VStack {
        ChatBubble(isFromAuthenticatedUser: true)
            .frame(width: 200, height: 44)
            .padding(.bottom)
        
        ChatBubble(isFromAuthenticatedUser: false)
            .frame(width: 200, height: 44)
    }
}
