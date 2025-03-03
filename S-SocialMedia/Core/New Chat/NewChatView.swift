//
//  NewChatView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import ErrorWrapper
import SwiftUI

struct NewChatView: View {
    @Binding var selectedChat: Chat?
    
    @Environment(AuthService.self) private var authService
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if viewModel.users.isEmpty {
                        ContentUnavailableView(
                            "No Users Available",
                            systemImage: "person.slash.fill",
                            description: Text(
                                "Click on Text field and type an username to find someone."
                            )
                        )
                    } else {
                        List(viewModel.users, id: \.id) { user in
                            UserProfileRow(
                                username: user.username,
                                text: user.bio ?? ""
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .listRowSeparator(
                                user.id == viewModel.users.first?.id ? .hidden : .visible ,
                                edges: .top
                            )
                            .onTapGesture {
                                if let currentUser = authService.userProfile {
                                    selectedChat = .init(
                                        currentUserID: currentUser.id,
                                        sender: currentUser,
                                        receiver: user,
                                        messages: []
                                    )
                                    
                                    dismiss()
                                }
                            }
                            
                        }
                    }
                }
            }
            .searchable(
                text: $viewModel.username,
                prompt: "Insert a username"
            )
            .textInputAutocapitalization(.never)
            .onSubmit(of: .search) {
                viewModel.fetchUsers(
                    currentUsername: authService.userProfile?.username ?? ""
                )
            }
            .errorAlert(error: $viewModel.error) { }
            .listStyle(.plain)
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}

#Preview {
    NewChatView(selectedChat: .constant(nil))
        .environment(AuthService())
}
