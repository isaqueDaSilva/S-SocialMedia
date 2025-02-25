//
//  ProfileView+ViewModel.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import ErrorWrapper
import Foundation
import Observation

extension ProfileView {
    @Observable
    @MainActor
    final class ViewModel {
        var isLogoutButtonLoading = false
        var isEditButtonLoaging = false
        var isEditable = false
        var isShowingEditProfilePictureDialog = false
        var isShowingLogoutAlert = false
        var error: ExecutionError? = nil
        var username = ""
        var bio = ""
        
        func set(username: String?, bio: String?) {
            self.username = username ?? "No username"
            self.bio = bio ?? "No bio"
        }
        
        func logout(completation: @escaping () async throws -> Void) {
            self.isLogoutButtonLoading = true
            
            Task {
                do {
                    try await completation()
                } catch {
                    await MainActor.run {
                        self.error = .init(
                            title: "Logout Failure",
                            descrition: error.localizedDescription
                        )
                    }
                }
                
                await MainActor.run {
                    self.isLogoutButtonLoading = false
                }
            }
        }
        
        func updateProfile(
            checker: @escaping (String, String) -> Bool,
            updater: @escaping (String?, String?) async throws -> Void
        ) {
            isEditButtonLoaging = true
            
            Task {
                do {
                    guard checker(username, bio) else {
                        await MainActor.run {
                            self.isEditable = false
                        }
                        
                        return
                    }
                    
                    
                    try await updater(username, bio)
                } catch {
                    await MainActor.run {
                        self.error = .init(
                            title: "Update Profile Failure",
                            descrition: error.localizedDescription
                        )
                    }
                }
                
                await MainActor.run {
                    isEditButtonLoaging = false
                    isEditable = false
                }
            }
        }
    }
}
