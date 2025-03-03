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
    
    private var isChannelsOn = false
    
    @ObservationIgnored
    private let logger = AppLogger(category: "AuthManager")
    
    func isChatExist(_ username: String) -> Chat? {
        chats.first(where: { $0.receiver.username == username })
    }
    
    func fetchMessages(userID: UUID) async throws {
        guard chatsDictionary.isEmpty else {
            logger.info("Messages already loaded, skipping fetch.")
            return
        }
        
        let messages: [Message] = try await Message.query()
            .or("creator.eq.\(userID),receiver.eq.\(userID)")
            .execute()
            .value
        
        logger.info("Was founded \(messages.count) with success.")
        
        await classifyMessages(messages, withCurrentUserID: userID)
        
        await MainActor.run {
            self.isChannelsOn = true
        }
    }
    
    private func classifyMessages(
        _ messages: [Message],
        withCurrentUserID userID: UUID
    ) async {
        for message in messages {
            if let chat = chatsDictionary[message.chatID] {
                await updateChatList(with: chat, andMessage: message)
                logger.info("A message was updated in the storage.")
            } else {
                await insertNewChat(currentUserID: userID, with: message)
                logger.info("A new message was added to the storage.")
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
    
    private func updateChatList(with chat: Chat, andMessage message: Message) async {
        await MainActor.run {
            chat.messages.append(message)
            
            logger.info("A message was updated in the storage.")
        }
    }
    
    func removeSubscription() async {
        await SupabaseHandler.shared.supabase.removeAllChannels()
        
        logger.info("All channels are clean.")
        
        for chat in chats {
            chat.removeSubscription()
            logger.info("Remove subscription from chennel \(chat.id) with success.")
        }
        
        await MainActor.run {
            self.isChannelsOn = false
        }
    }
    
    func subscribeInChannels() {
        guard !isChannelsOn && !chats.isEmpty else { return }
        
        for chat in chats {
            chat.subscribeInChannel()
            logger.info("Subscribe in \(chat.id) channel with success.")
        }
    }
    
    func removeAllChats() {
        self.chatsDictionary.removeAll()
        logger.info("All messages was removed from the memory.")
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.removeAllChats()
        }
    }
}
