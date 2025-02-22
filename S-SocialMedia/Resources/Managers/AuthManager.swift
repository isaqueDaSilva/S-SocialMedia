//
//  AuthManager.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//

import ErrorWrapper
import Foundation
import Observation
import os.log
import Supabase

@Observable
@MainActor
final class AuthManager {
    var userProfile: UserProfile?
    var isAuthenticated: Bool = false
    
    private func getUser() async throws -> User {
        let user = await SupabaseHandler.shared.auth.currentUser
        
        guard let user else {
            throw ExecutionError.noUser
        }
        
        return user
    }
    
    func signIn(withCredentials credentials: UserCreadentials) async throws {
        try await SupabaseHandler.shared.auth.signIn(
            email: credentials.email,
            password: credentials.password
        )
        
        try await getUserProfile()
    }
    
    func getUserProfile() async throws {
        let currentUser = try await getUser()
        
        let profile: UserProfile = try await SupabaseHandler.shared.supabase
            .from("profiles")
            .select()
            .eq("id", value: currentUser.id)
            .single()
            .execute()
            .value
        
        await MainActor.run {
            self.userProfile = profile
            self.isAuthenticated = true
        }
    }
    
    func signUp(withCredentials credentials: UserCreadentials) async throws {
        try await SupabaseHandler.shared.auth.signUp(
            email: credentials.email,
            password: credentials.password
        )
    }
    
    func createProfile(with profileFields: UserProfile) async throws {
        let currentUser = try await getUser()
        
        var profile = profileFields
        profile.userID = currentUser.id
        
        let userProfile: UserProfile = try await SupabaseHandler.shared.supabase
            .from("profiles")
            .insert(profile)
            .select()
            .single()
            .execute()
            .value
        
        await MainActor.run {
            self.userProfile = userProfile
            self.isAuthenticated = true
        }
    }
    
    func signOut() async throws {
        try await SupabaseHandler.shared.auth.signOut()
        
        await MainActor.run {
            self.userProfile = nil
            self.isAuthenticated = false
        }
    }
    
    func checkCurrentAuthState() async throws {
        let session = try await SupabaseHandler.shared.auth.session
        
        if !session.isExpired {
            do {
                try await getUserProfile()
            } catch {
                throw error
            }
        }
    }
    
    func checkAuthStatus() {
        Task {
            for await (_, session) in await SupabaseHandler.shared.auth.authStateChanges {
                await MainActor.run {
                    self.isAuthenticated = session?.user != nil
                }
            }
        }
    }
}
