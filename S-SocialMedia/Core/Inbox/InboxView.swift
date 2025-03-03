//
//  InboxView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct InboxView: View {
    @Environment(MessageService.self) private var messageService
    @Environment(AuthService.self) private var authService
    
    @State private var showAddNewChat = false
    @State private var selectedChat: Chat?
    @State private var path: [Navigation] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if messageService.chats.isEmpty {
                    ContentUnavailableView(
                        "No chats available",
                        systemImage: "square.slash",
                        description: Text("Click on + button and create a new chat.")
                    )
                } else {
                    List(messageService.chats, id: \.id) { chat in
                        NavigationLink(value: Navigation.chat(chat)) {
                            InboxRow(
                                username: chat.receiver.username,
                                message: chat.messages.last?.message ?? "",
                                sendedAt: chat.messages.last?.sentAt
                            )
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            path.append(.userProfile)
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundStyle(Color.gray)
                                .frame(width: 32, height: 32)
                        }
                        
                        Button {
                            showAddNewChat = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddNewChat) {
                if let selectedChat {
                    if let chat = messageService.isChatExist(selectedChat.receiver.username) {
                        self.path.append(.chat(chat))
                    } else {
                        self.path.append(.chat(selectedChat))
                    }
                }
            } content: {
                NewChatView(selectedChat: $selectedChat)
                    .environment(authService)
            }
            .navigationDestination(for: Navigation.self) { navigation in
                switch navigation {
                case .chat(let chat):
                    if let userID = authService.userProfile?.id {
                        ChatView(currentUserID: userID, chat: chat)
                    }
                case .userProfile:
                    ProfileView()
                        .environment(authService)
                }
            }
        }
    }
}

#Preview {
    InboxView()
        .environment(AuthService())
        .environment(MessageService())
}
