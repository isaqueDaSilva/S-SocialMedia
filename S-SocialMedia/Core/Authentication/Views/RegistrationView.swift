//
//  RegistrationView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    var body: some View {
        VStack {
            LogoView()
                .padding(.bottom, 20)
            
            textFields
                .padding(.bottom, 5)
            
            signUPButton
        }
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
                text: $email
            )
            .textFieldDefaultStyle()
            
            SecureField(
                "Insert yur password here...",
                text: $password
            )
            .textFieldDefaultStyle()
            
            TextField("Insert an username here...", text: $username)
                .textFieldDefaultStyle()
        }
    }
    
    @ViewBuilder
    private var signUPButton: some View {
        PrimaryButton(title: "Sign up") {
            
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
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
}
