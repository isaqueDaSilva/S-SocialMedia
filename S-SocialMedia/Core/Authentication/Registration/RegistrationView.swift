//
//  RegistrationView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import ErrorWrapper
import SwiftUI

struct RegistrationView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            LogoView()
                .padding(.bottom, 20)
            
            textFields
                .padding(.bottom, 5)
            
            signUPButton
        }
        .disabled(viewModel.isLoading)
        .errorAlert(error: $viewModel.error) { }
        .navigationBarBackButtonHidden()
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                dismissButton
            }
        }
    }
}

extension RegistrationView {
    @ViewBuilder
    private var textFields: some View {
        VStack(spacing: 10) {
            TextField(
                "Insert your email here",
                text: $viewModel.userCredentials.email
            )
            .textFieldDefaultStyle()
            
            SecureField(
                "Insert yur password here...",
                text: $viewModel.userCredentials.password
            )
            .textFieldDefaultStyle()
            
            TextField(
                "Insert an username here...",
                text: $viewModel.userProfile.username
            )
            .textFieldDefaultStyle()
            
        }
    }
    
    @ViewBuilder
    private var signUPButton: some View {
        PrimaryButton(isLoading: $viewModel.isLoading, title: "Sign up") {
            viewModel.createAccount { credentials in
                try await authManager.signUp(withCredentials: credentials)
            } createProfile: { profile in
                try await authManager.createProfile(with: profile)
            }

        }
    }
    
    @ViewBuilder
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            SecondaryLabel(
                primaryText: "Already have an account?",
                secondaryText: "Sign In"
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
    .environment(AuthManager())
}
