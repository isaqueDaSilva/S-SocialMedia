//
//  RegistrationView+ViewModel.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import ErrorWrapper
import Foundation
import Observation

extension RegistrationView {
    @Observable
    @MainActor
    final class ViewModel {
        var error: ExecutionError?
        var userCredentials = UserCreadentials()
        var userProfile = UserProfile()
        var isLoading = false
        
        @ObservationIgnored
        private let logger = AppLogger(category: "Registration+ViewModel")
        
        private func checkFields() async {
            guard !userCredentials.email.isEmpty,
                  !userCredentials.password.isEmpty,
                  !userProfile.username.isEmpty
            else {
                return await MainActor.run {
                    self.error = .fieldsEmpty
                }
            }
        }
        
        func createAccount(
            signUpCompletation: @escaping (UserCreadentials, UserProfile) async throws -> Void
        ) {
            Task {
                await checkFields()
                
                do {
                    try await signUpCompletation(self.userCredentials, userProfile)
                    
                    logger.info("Registration occur in correct away.")
                } catch {
                    logger.error("Registration Failed. Error: \(error.localizedDescription)")
                    
                    await MainActor.run {
                        self.error = .init(
                            title: "Failed to Create Account",
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
