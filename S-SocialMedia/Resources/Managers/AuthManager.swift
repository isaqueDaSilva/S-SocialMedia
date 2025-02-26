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
    
    @ObservationIgnored
    private let logger = AppLogger(category: "AuthManager")
    
    func signIn(withCredentials credentials: UserCreadentials) async throws {
        try await SupabaseHandler.shared.auth.signIn(
            email: credentials.email,
            password: credentials.password
        )
        
        logger.info("The sign in action was executed with success.")
        
        try await getUserProfile()
    }
    
    func signUp(withCredentials credentials: UserCreadentials) async throws {
        try await SupabaseHandler.shared.auth.signUp(
            email: credentials.email,
            password: credentials.password
        )
        
        logger.info("The sign up action was executed with success.")
    }
    
    func signOut() async throws {
        try await SupabaseHandler.shared.auth.signOut()
        
        await MainActor.run {
            self.userProfile = nil
            self.isAuthenticated = false
        }
        
        logger.info("The sign out action was executed with success.")
    }
    
    func checkCurrentAuthState() async throws {
        guard let session = try? await SupabaseHandler.shared.auth.session else {
            logger.error("The session was not founded.")
            
            return
        }
        
        if !session.isExpired {
            do {
                try await getUserProfile()
            } catch {
                logger.error("An error occur when we try to find the user profile.")
                
                throw error
            }
        }
    }
    
    func checkAuthStatus() {
        Task {
            for await (_, session) in await SupabaseHandler.shared.auth.authStateChanges {
                await MainActor.run {
                    self.isAuthenticated = session?.user != nil
                    
                    logger.info("AUTH STATE: \(session?.isExpired.description ?? "false")")
                }
            }
        }
    }
    
    private func getUser() async throws -> User {
        let user = await SupabaseHandler.shared.auth.currentUser
        
        guard let user else {
            logger.error("Failed to get the user profile.")
            throw ExecutionError.noUser
        }
        
        logger.info("The user instance was founded with success.")
        return user
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
        
        logger.info("User profile was created with success.")
        
        await MainActor.run {
            self.userProfile = userProfile
            self.isAuthenticated = true
        }
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
        
        logger.info("User profile was founded with success.")
        
        await MainActor.run {
            self.userProfile = profile
            self.isAuthenticated = true
        }
    }
    
    func isProfileUpdated(
        username: String,
        bio: String
    ) -> Bool {
        (userProfile?.username != username) && !username.isEmpty ||
        userProfile?.bio != bio
    }
    
    func updateUserProfile(
        username: String?,
        bio: String?
    ) async throws {
        let currentUser = try await getUser()
        
        let profile: UserProfile = try await SupabaseHandler.shared.supabase
            .from("profiles")
            .update(["bio": bio, "username": username])
            .eq("id", value: currentUser.id)
            .select()
            .single()
            .execute()
            .value
        
        logger.info("User profile was updated with success.")
        
        await MainActor.run {
            self.userProfile = profile
        }
    }
}
