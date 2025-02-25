//
//  NewChatView+ViewModel.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/21/25.
//

import ErrorWrapper
import Foundation
import Observation

extension NewChatView {
    @Observable
    @MainActor
    final class ViewModel {
        var isLoading = false
        var username = ""
        var users: [UserProfile] = []
        var error: ExecutionError? = nil
        
        func fetchUsers(currentUsername: String) {
            self.isLoading = true
            
            guard username != currentUsername else { return }
            
            Task {
                do {
                    let users: [UserProfile] = try await SupabaseHandler.shared.supabase
                        .from("profiles")
                        .select()
                        .eq("username", value: self.username)
                        .execute()
                        .value
                    
                    await MainActor.run {
                        self.users = users
                    }
                } catch {
                    await MainActor.run {
                        self.error = .init(
                            title: "Fetch User action failed",
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
