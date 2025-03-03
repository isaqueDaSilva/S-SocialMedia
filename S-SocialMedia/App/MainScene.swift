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
    @State private var authService = AuthService()
    @State private var messagesService = MessageService()
    @State private var error: ExecutionError? = nil
    @State private var removeSubscriptionTask: Task<Void, Never>?
    
    private let logger = AppLogger(category: "MainScene")
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isSplashScreenShowing {
                    SplashScreen(isSplashViewShowing: $isSplashScreenShowing)
                } else {
                    RootView()
                        .environment(authService)
                        .environment(messagesService)
                }
            }
            .errorAlert(error: $error) { }
            .onAppear {
                checkCurrentAuthState()
                
                if authService.isAuthenticated {
                    // Runs only if has chats saved and the channels are unsubscribed.
                    messagesService.subscribeInChannels()
                }
                
                authService.checkAuthStatusChanges()
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                if newValue == .inactive && oldValue == .active {
                    removeAllChannels(hasCancelationTime: true)
                }
                
                if (oldValue == .inactive || oldValue == .background) && newValue == .active {
                    if removeSubscriptionTask != nil {
                        removeSubscriptionTask?.cancel()
                        logger.info("Remove subscription channel task with success.")
                    }
                }
            }
            .onChange(of: authService.userProfile) { oldValue, newValue in
                if oldValue == nil && newValue != nil {
                    fetchMessages()
                } else {
                    removeAllChannels(hasCancelationTime: false)
                    messagesService.removeAllChats()
                }
            }
        }
    }
}

extension MainScene {
    private func checkCurrentAuthState() {
        Task {
            do {
                try await authService.checkCurrentAuthState()
                
                logger.info("Auth state was fetched with success.")
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
    }
    
    private func fetchMessages() {
        Task {
            do {
                if let userID = authService.userProfile?.id {
                    try await messagesService.fetchMessages(userID: userID)
                    
                    logger.info("The messages are fetched with success.")
                }
            } catch {
                await MainActor.run {
                    self.error = .init(
                        title: "Failed to Fetch messages.",
                        descrition: error.localizedDescription
                    )
                }
            }
        }
    }
    
    private func removeAllChannels(hasCancelationTime: Bool) {
        removeSubscriptionTask = Task {
            if hasCancelationTime {
                logger.info("Await for remove all subscribed channels.")
                try? await Task.sleep(for: .seconds(300))
            }
            
            await messagesService.removeSubscription()
            
            logger.info("All channels are clean.")
        }
    }
}
