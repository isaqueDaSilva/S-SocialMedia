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
    
    func subscribeInChannel() {
        Task {
            let channel = await SupabaseHandler.shared.supabase.channel(id.uuidString)
            
            let changeStream = channel.postgresChange(
                InsertAction.self,
                schema: "public",
                table: "messages"
            )
            
            await channel.subscribe()
            
            for await action in changeStream {
                await insertMessage(withAction: action)
            }
        }
    }
    
    private func insertMessage(withAction action: InsertAction) async {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let messageDecoded = try? action.decodeRecord(as: Message.DecodedMessage.self, decoder: JSONDecoder()),
              let message = messageDecoded.toMessage(currentUser: self.sender, receiverUser: self.receiver)
        else {
            return
        }
        
        await MainActor.run {
            self.messages.append(message)
        }
    }
    
    func sendMessage(_ message: String) async throws {
        let newMessage = Message(
            chatID: id,
            creator: sender,
            receiver: receiver,
            message: message
        )
        
        try await SupabaseHandler.shared.supabase
            .from("messages")
            .insert(newMessage)
            .execute()
    }
    
    func fetchMessages() async throws {
        let messages: [Message] = try await Message.query()
            .eq("chat_id", value: self.id)
            .execute()
            .value
        
        await MainActor.run {
            self.messages = messages
        }
    }
    
    init(id: UUID = .init(), sender: UserProfile, receiver: UserProfile, messages: [Message]) {
        self.id = id
        self.sender = sender
        self.receiver = receiver
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
