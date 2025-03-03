//
//  Chat.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/22/25.
//

import Foundation
import Supabase
import Observation

@Observable
@MainActor
final class Chat: Identifiable {
    let id: UUID
    let sender: UserProfile
    let receiver: UserProfile
    var messages: [Message]
    
    @ObservationIgnored
    private let logger = AppLogger(category: "Chat")
    
    @ObservationIgnored
    private var subscriptionTask: Task<Void, Never>?
    
    func subscribeInChannel() {
        subscriptionTask?.cancel()
        
        subscriptionTask = Task {
            let channel = SupabaseHandler.shared.supabase.channel(id.uuidString)
            
            let changeStream = channel.postgresChange(
                InsertAction.self,
                schema: "public",
                table: "messages",
                filter: "chat_id=eq.\(self.id)"
            )
            
            await channel.subscribe()
            
            logger.info("Subscribe in the channel \(id) with success.")
            
            for await action in changeStream {
                await insertMessage(withAction: action)
                logger.info("New message was inserted with success.")
            }
        }
    }
    
    func removeSubscription() {
        guard subscriptionTask != nil else { return }
        
        subscriptionTask = nil
        
        logger.info("Chat subscrition removed with success.")
    }
    
    private func insertMessage(withAction action: InsertAction) async {
        do {
            let messageDecoded = try action.decodeRecord(as: Message.DecodedMessage.self, decoder: JSONDecoder())
            guard let message = messageDecoded.toMessage(currentUser: self.sender, receiverUser: self.receiver) else {
                logger.info("The message cannot be added to the stack, because it's value is nil.")
                return
            }
            
            logger.info("The new message was decoded.")
            
            await MainActor.run {
                self.messages.append(message)
                logger.info("A new message was inserted in the collection.")
            }
        } catch {
            logger.error("Failed to decode or add message to the stack: \(error.localizedDescription)")
        }
    }
    
    func sendMessage(_ message: String) async throws {
        let newMessage = Message(
            chatID: id,
            creator: self.sender,
            receiver: self.receiver,
            message: message
        )
        
        try await SupabaseHandler.shared.supabase
            .from("messages")
            .insert(newMessage)
            .execute()
        
        logger.info("A new message was sent with success.")
        
        
        if subscriptionTask == nil {
            await MainActor.run {
                self.messages.append(newMessage)
            }
            self.subscribeInChannel()
        }
    }
    
    func fetchMessages() async throws {
        let messages: [Message] = try await Message.query()
            .eq("chat_id", value: self.id)
            .execute()
            .value
        
        logger.info("The messages was fetched with success. Was returned back \(messages.count) messages.")
        
        await MainActor.run {
            self.messages = messages
        }
    }
    
    init(id: UUID = .init(), currentUserID: UUID, sender: UserProfile, receiver: UserProfile, messages: [Message]) {
        let (userSender, userReceiver) = if currentUserID == sender.id {
            (sender, receiver)
        } else {
            (receiver, sender)
        }
        
        self.id = id
        self.sender = userSender
        self.receiver = userReceiver
        self.messages = messages
    }
}

extension Chat: Hashable {
    nonisolated
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
    
    nonisolated
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.sender.id)
        hasher.combine(self.receiver.id)
    }
}

#if DEBUG
extension Chat {
    static let mock = Chat(
        currentUserID: .init(),
        sender: .mock,
        receiver: .mock,
        messages: [
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init(),
            .init()
        ]
    )
}
#endif
