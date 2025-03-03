//
//  FriendProfileView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import SwiftUI

struct FriendProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    let user: UserProfile
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Username") {
                    Text(user.username)
                }
                
                Section("Bio") {
                    Text(user.bio ?? "No Bio")
                }
            }
            .navigationTitle("Friend Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendProfileView(user: .mock)
    }
}
