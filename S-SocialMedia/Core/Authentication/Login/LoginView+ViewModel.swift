//
//  LoginView+ViewModel.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import ErrorWrapper
import Foundation
import Observation

extension LoginView {
    @Observable
    @MainActor
    final class ViewModel {
        var error: ExecutionError? = nil
        var credentials = UserCreadentials()
        var isLoading = false
        
        @ObservationIgnored
        private let logger = AppLogger(category: "Login+ViewModel")
        
        private func isFieldsValid() async -> Bool {
            guard !credentials.email.isEmpty && !credentials.password.isEmpty
            else {
                await MainActor.run {
                    self.error = .fieldsEmpty
                    self.isLoading = false
                }
                
                logger.info("The fields is not valid to flow for the next task.")
                
                return false
            }
            
            logger.info("The fields are valid to flow for the next steps.")
            
            return true
        }
        
        func login(completation: @escaping (UserCreadentials) async throws -> Void) {
            Task {
                guard await isFieldsValid() else { return }
                
                do {
                    try await completation(self.credentials)
                    
                    logger.info("Login was made with success.")
                } catch {
                    
                    await MainActor.run {
                        logger.error("Login Error: \(error.localizedDescription)")
                        
                        self.error = .init(
                            title: "Login Error",
                            descrition: error.localizedDescription
                        )
                    }
                }
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
