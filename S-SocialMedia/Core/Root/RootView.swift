//
//  RootView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct RootView: View {
    @Environment(MessageService.self) private var messageService
    @Environment(AuthManager.self) private var authManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                InboxView()
                    .environment(messageService)
            } else {
                LoginView()
            }
        }
        .environment(authManager)
    }
}

#Preview {
    RootView()
        .environment(AuthManager())
        .environment(MessageService())
}
