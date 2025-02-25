//
//  MainScene.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/21/25.
//

import ErrorWrapper
import SwiftUI

struct MainScene: Scene {
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isSplashScreenShowing = true
    @State private var authManager = AuthManager()
    @State private var messagesService = MessageService()
    @State private var error: ExecutionError? = nil
    
    private let logger = AppLogger(category: "MainScene")
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isSplashScreenShowing {
                    SplashScreen(isSplashViewShowing: $isSplashScreenShowing)
                } else {
                    ContentView()
                        .environment(authManager)
                        .environment(messagesService)
                }
            }
            .errorAlert(error: $error) { }
            .onAppear {
                Task {
                    do {
                        try await authManager.checkCurrentAuthState()
                        
                        if let userID = authManager.userProfile?.id {
                            try await messagesService.fetchMessages(userID: userID)
                        }
                        
                        logger.info("Auth state and user profile fetched with success.")
                    } catch {
                        logger.info(
                            "Error to fetch the auth state and user profile. Error: \(error.localizedDescription)"
                        )
                        
                        await MainActor.run {
                            self.error = .init(
                                title: "Failed to Initialize the app correctly.",
                                descrition: error.localizedDescription
                            )
                        }
                    }
                }
                
                authManager.checkAuthStatus()
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .inactive {
                    Task {
                        await SupabaseHandler.shared.supabase.removeAllChannels()
                        
                        logger.info("All channels are clean.")
                    }
                }
            }
        }
    }
}
