//
//  ProfileView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import ErrorWrapper
import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(AuthService.self) private var authService
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        List {
            Section("Username") {
                usernameField
            }
            
            Section("Bio") {
                bioField
            }
            
            Section {
                logOutButton
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            Button {
                if viewModel.isEditable {
                    viewModel.updateProfile { username, bio in
                        authService.isProfileUpdated(
                            username: username,
                            bio: bio
                        )
                    } updater: { username, bio in
                        try await authService.updateUserProfile(
                            username: username,
                            bio: bio
                        )
                    }

                } else {
                    viewModel.isEditable = true
                }

            } label: {
                if viewModel.isEditButtonLoaging {
                    ProgressView()
                } else {
                    Text(viewModel.isEditable ? "Done" : "Edit")
                }
            }
        }
        .onAppear {
            self.viewModel.set(
                username: self.authService.userProfile?.username,
                bio: self.authService.userProfile?.bio
            )
        }
        .alert(
            "Are you sure to logout from your account?",
            isPresented: $viewModel.isShowingLogoutAlert
        ) {
            Button(role: .destructive) {
                viewModel.logout {
                    try await authService.signOut()
                }
            } label: {
                if viewModel.isLogoutButtonLoading {
                    ProgressView()
                } else {
                    Text("OK")
                }
            }
        }
    }
}

// MARK: - Views -
extension ProfileView {
    @ViewBuilder
    private var usernameField: some View {
        if viewModel.isEditable {
            TextField("Username", text: $viewModel.username)
        } else {
            Text(viewModel.username)
        }
    }
    
    @ViewBuilder
    private var bioField: some View {
        Group {
            if viewModel.isEditable {
                TextField("Bio", text: $viewModel.bio, axis: .vertical)
            } else {
                Text(viewModel.bio)
            }
        }
        .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var logOutButton: some View {
        Button("Logout", role: .destructive) {
            self.viewModel.isShowingLogoutAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(AuthService())
    }
}
