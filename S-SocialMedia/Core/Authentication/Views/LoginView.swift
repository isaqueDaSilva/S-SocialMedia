//
//  LoginView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                LogoView()
                    .padding(.bottom, 20)
                    
                textFields
                    .padding(.bottom, 5)
                
                loginButton
                
                forgotPasswordButton
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    createAnAccountNavigation
                }
            }
        }
    }
}

extension LoginView {
    @ViewBuilder
    private var textFields: some View {
        VStack(spacing: 10) {
            TextField(
                "Insert your email here",
                text: $email
            )
            .textFieldDefaultStyle()
            
            SecureField(
                "Insert yur password here...",
                text: $password
            )
            .textFieldDefaultStyle()
        }
    }
    
    @ViewBuilder
    private var loginButton: some View {
        PrimaryButton(title: "Login") {
            
        }
    }
    
    @ViewBuilder
    private var forgotPasswordButton: some View {
        SecondaryButton(title: "Forgot Password?") {
            
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
    }
}

#Preview {
    LoginView()
}
