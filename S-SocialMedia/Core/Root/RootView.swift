//
//  RootView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct RootView: View {
    @Environment(MessageService.self) private var messageService
    @Environment(AuthService.self) private var authService
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                InboxView()
                    .environment(messageService)
            } else {
                LoginView()
            }
        }
        .environment(authService)
    }
}

#Preview {
    RootView()
        .environment(AuthService())
        .environment(MessageService())
}
