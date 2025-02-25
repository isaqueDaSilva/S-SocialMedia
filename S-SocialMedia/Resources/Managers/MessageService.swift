//
//  MessageService.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/22/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class MessageService {
    private var chatsDictionary = [UUID: Chat]()
    
    var chats: [Chat] {
        chatsDictionary.toArray
    }
    
    func fetchMessages(userID: UUID) async throws {
        let messages: [Message] = try await Message.query()
            .or("creator.eq.\(userID),receiver.eq.\(userID)")
            .execute()
            .value
        
        await classifyMessages(messages)
    }
    
    private func classifyMessages(_ messages: [Message]) async {
        for message in messages {
            if chatsDictionary[message.chatID] == nil {
                await insertNewChat(with: message)
            } else {
                await updateChatList(with: message)
            }
        }
    }
    
    private func insertNewChat(with message: Message) async {
        let newChat = Chat(
            id: message.chatID,
            sender: message.creator,
            receiver: message.receiver,
            messages: [message]
        )
        
        newChat.subscribeInChannel()
        
        await MainActor.run {
            chatsDictionary[newChat.id] = newChat
        }
    }
    
    private func updateChatList(with message: Message) async {
        await MainActor.run {
            chatsDictionary[message.chatID]?.messages.append(message)
        }
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.chatsDictionary.removeAll()
        }
    }
}
