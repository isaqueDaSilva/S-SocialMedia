//
//  PrimaryButton.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct PrimaryButton: View {
    @Binding var isLoading: Bool
    
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button {
            self.isLoading = true
            action()
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color(uiColor: .systemBlue))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1)
    }
    
    init(isLoading: Binding<Bool>, title: String, action: @escaping () -> Void) {
        self._isLoading = isLoading
        self.title = title
        self.action = action
    }
}

#Preview {
    PrimaryButton(isLoading: .constant(false), title: "Login") { }
    PrimaryButton(isLoading: .constant(true), title: "Login") { }
}
