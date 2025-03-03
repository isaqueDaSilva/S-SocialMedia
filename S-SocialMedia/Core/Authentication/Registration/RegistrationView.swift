//
//  RegistrationView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import ErrorWrapper
import SwiftUI

struct RegistrationView: View {
    @Environment(AuthService.self) private var authService
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
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
            
            SecureField(
                "Insert yur password here...",
                text: $viewModel.userCredentials.password
            )
            .textFieldDefaultStyle()
            .submitLabel(.next)
            
            TextField(
                "Insert an username here...",
                text: $viewModel.userProfile.username
            )
            .textFieldDefaultStyle()
            .textInputAutocapitalization(.never)
            .submitLabel(.go)
        }
    }
    
    @ViewBuilder
    private var signUPButton: some View {
        PrimaryButton(isLoading: $viewModel.isLoading, title: "Sign up") {
            viewModel.createAccount { credentials, profile in
                try await authService.signUp(
                    withCredentials: credentials,
                    profile: profile
                )
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
    .environment(AuthService())
}
