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
        
        func login(completation: @escaping (UserCreadentials) async throws -> Void) {
            Task {
                guard !credentials.email.isEmpty &&
                        !credentials.password.isEmpty
                else {
                    return await MainActor.run {
                        self.error = .fieldsEmpty
                    }
                }
                
                do {
                    try await completation(self.credentials)
                } catch {
                    
                    await MainActor.run {
                        self.error = .init(
                            title: "Login Error",
                            descrition: error.localizedDescription
                        )
                    }
                }
            }
        }
    }
}
