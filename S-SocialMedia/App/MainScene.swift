//
//  MainScene.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/21/25.
//

import ErrorWrapper
import SwiftUI

struct MainScene: Scene {
    @State private var isSplashScreenShowing = true
    @State private var authManager = AuthManager()
    @State private var error: ExecutionError? = nil
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isSplashScreenShowing {
                    SplashScreen(isSplashViewShowing: $isSplashScreenShowing)
                } else {
                    ContentView()
                        .environment(authManager)
                }
            }
            .errorAlert(error: $error) { }
            .onAppear {
                Task {
                    do {
                        try await authManager.checkCurrentAuthState()
                    } catch {
                        await MainActor.run {
                            self.error = .init(
                                title: "Failed to check your Auth State",
                                descrition: error.localizedDescription
                            )
                        }
                    }
                }
                
                authManager.checkAuthStatus()
            }
        }
    }
}
