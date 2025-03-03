//
//  LoginView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import ErrorWrapper
import SwiftUI

struct LoginView: View {
    @Environment(AuthService.self) private var authService
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                LogoView()
                    .padding(.bottom, 20)
                    
                textFields
                    .padding(.bottom, 5)
                
                loginButton
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    createAnAccountNavigation
                }
            }
            .errorAlert(error: $viewModel.error) { }
        }
    }
}

extension LoginView {
    @ViewBuilder
    private var textFields: some View {
        VStack(spacing: 10) {
            TextField(
                "Insert your email here",
                text: $viewModel.credentials.email
            )
            .textFieldDefaultStyle()
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
            
            SecureField(
                "Insert your password here...",
                text: $viewModel.credentials.password
            )
            .textFieldDefaultStyle()
            .submitLabel(.go)
        }
    }
    
    @ViewBuilder
    private var loginButton: some View {
        PrimaryButton(isLoading: $viewModel.isLoading, title: "Login") {
            viewModel.login { credentials in
                try await authService.signIn(withCredentials: credentials)
            }
        }
    }
    
    @ViewBuilder
    private var createAnAccountNavigation: some View {
        NavigationLink {
            RegistrationView()
        } label: {
            SecondaryLabel(
                primaryText: "Don't have an account?",
                secondaryText: "Sign Up"
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LoginView()
        .environment(AuthService())
}
