//
//  ChatView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//

import ErrorWrapper
import SwiftUI

struct ChatView: View {
    let currentUserID: UUID
    @Bindable var chat: Chat
    
    @State private var viewModel = ViewModel()
    @State private var scrollPosition = ScrollPosition()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(chat.messages, id: \.id) { message in
                    MessageCell(
                        isFromCurrentUser: viewModel.isFromCurrentUser(
                            currentUserID: chat.sender.id,
                            senderUserID: message.creator.id
                        ),
                        message: message.message
                    )
                }
            }
            .padding(.horizontal)
        }
        .defaultScrollAnchor(.bottom)
        .scrollPosition($scrollPosition)
        .animation(.spring, value: scrollPosition)
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert(error: $viewModel.error) { }
        .toolbar {
            Button(chat.receiver.username) {
                viewModel.showFriedDetails = true
            }
            .buttonStyle(.borderedProminent)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField(
                    "Type a message",
                    text: $viewModel.message,
                    axis: .vertical
                )
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
                .textFieldDefaultStyle(
                    backgroundColor: .secondary,
                    padding: 8
                )
                .onTapGesture {
                    scrollPosition = .init(edge: .bottom)
                }
                    
            
                Button {
                    viewModel.sendMessage { message in
                        try await chat.sendMessage(message)
                        
                        await MainActor.run {
                            scrollPosition = .init(edge: .bottom)
                        }
                    }
                    
                    if chat.messages.isEmpty {
                        chat.subscribeInChannel()
                    }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "paperplane.circle.fill")
                                .resizable()
                        }
                    }
                    .frame(width: 32, height: 32)
                }
                .opacity(viewModel.message.isEmpty ? 0.7 : 1)
                .disabled(viewModel.message.isEmpty)
            }
            .sheet(isPresented: $viewModel.showFriedDetails) {
                FriendProfileView(user: self.chat.receiver)
                    .presentationDetents([.fraction(1/2)])
            }
            .animation(.spring.delay(0.15), value: viewModel.message)
            .padding()
            .background {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(currentUserID: .init(), chat: .mock)
    }
}
