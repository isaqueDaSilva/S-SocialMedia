//
//  ViewModel.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import ErrorWrapper
import Foundation
import Observation

extension ChatView {
    @Observable
    @MainActor
    final class ViewModel {
        var showFriedDetails = false
        var message = ""
        var isLoading = false
        var error: ExecutionError?
       
        @ObservationIgnored
        private let logger = AppLogger(category: "Chat+ViewModel")
        
        func isFromCurrentUser(currentUserID: UUID, senderUserID: UUID) -> Bool {
            currentUserID == senderUserID
        }
        
        func sendMessage(completation: @escaping (String) async throws -> Void) {
            self.isLoading = true
            
            Task {
                do {
                    try await completation(self.message)
                    
                    logger.info("Message was sent with success.")
                } catch {
                    logger.error("Failed to send message. Error: \(error.localizedDescription)")
                    
                    await MainActor.run {
                        self.error = .init(
                            title: "Failed to send Message",
                            descrition: error.localizedDescription
                        )
                    }
                }
                
                await MainActor.run {
                    if error == nil {
                        self.message = ""
                    }
                    
                    self.isLoading = false
                }
            }
        }
    }
}
