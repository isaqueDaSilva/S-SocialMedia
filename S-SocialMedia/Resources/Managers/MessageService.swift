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
    
    @ObservationIgnored
    private let logger = AppLogger(category: "AuthManager")
    
    func fetchMessages(userID: UUID) async throws {
        let messages: [Message] = try await Message.query()
            .or("creator.eq.\(userID),receiver.eq.\(userID)")
            .execute()
            .value
        
        logger.info("Was founded \(messages.count) with success.")
        
        await classifyMessages(messages, withCurrentUserID: userID)
    }
    
    private func classifyMessages(
        _ messages: [Message],
        withCurrentUserID userID: UUID
    ) async {
        for message in messages {
            if chatsDictionary[message.chatID] == nil {
                await insertNewChat(currentUserID: userID, with: message)
                
                logger.info("A new message was added to the storage.")
            } else {
                await updateChatList(with: message)
                logger.info("A message was updated in the storage.")
            }
        }
    }
    
    private func insertNewChat(currentUserID: UUID, with message: Message) async {
        let newChat = Chat(
            id: message.chatID,
            currentUserID: currentUserID,
            sender: message.creator,
            receiver: message.receiver,
            messages: [message]
        )
        
        newChat.subscribeInChannel()
        
        await MainActor.run {
            chatsDictionary[newChat.id] = newChat
            
            logger.info("A new message was added to the storage.")
        }
    }
    
    private func updateChatList(with message: Message) async {
        await MainActor.run {
            chatsDictionary[message.chatID]?.messages.append(message)
            
            logger.info("A message was updated in the storage.")
        }
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.chatsDictionary.removeAll()
            
            logger.info("All messages was removed from the memory.")
        }
    }
}
