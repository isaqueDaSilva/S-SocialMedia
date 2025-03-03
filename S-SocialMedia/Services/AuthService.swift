//
//  AuthService.swift
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
final class AuthService {
    var userProfile: UserProfile?
    var isAuthenticated: Bool = false
    
    @ObservationIgnored
    private let logger = AppLogger(category: "AuthManager")
    
    @ObservationIgnored
    private var subscriptionTask: Task<Void, Never>?
    
    func signIn(withCredentials credentials: UserCreadentials) async throws {
        try await SupabaseHandler.shared.auth.signIn(
            email: credentials.email,
            password: credentials.password
        )
        
        logger.info("The sign in action was executed with success.")
        
        try await getUserProfile()
    }
    
    func signUp(withCredentials credentials: UserCreadentials, profile: UserProfile) async throws {
        let authResponse = try await SupabaseHandler.shared.auth.signUp(
            email: credentials.email,
            password: credentials.password
        )
        
        try await createProfile(with: profile, userID: authResponse.user.id)
        
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
    
    func checkAuthStatusChanges() {
        subscriptionTask?.cancel()
        
        subscriptionTask = Task {
            for await (_, session) in await SupabaseHandler.shared.auth.authStateChanges {
                let isAuthenticated = session?.user != nil
                
                if self.isAuthenticated != isAuthenticated {
                    await MainActor.run {
                        self.isAuthenticated = isAuthenticated
                    }
                    logger.info("Auth state changed: \(isAuthenticated)")
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
    
    private func createProfile(with profileFields: UserProfile, userID: UUID) async throws {
        var profile = profileFields
        profile.userID = userID
        
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
        guard userProfile == nil else { return }
        
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
        ((userProfile?.username != username) && !username.isEmpty) || (userProfile?.bio != bio)
    }
    
    func updateUserProfile(
        username: String?,
        bio: String?
    ) async throws {
        let currentUser = try await getUser()
        
        var updatedFields = [String: String]()
        
        if let username, (username != userProfile?.username) {
            updatedFields["username"] = username
        }
        
        if let bio, (bio != userProfile?.bio) {
            updatedFields[bio] = bio
        }
        
        guard !updatedFields.isEmpty else { return }
        
        let profile: UserProfile = try await SupabaseHandler.shared.supabase
            .from("profiles")
            .update(updatedFields)
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
