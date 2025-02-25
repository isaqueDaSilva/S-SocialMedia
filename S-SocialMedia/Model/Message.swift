//
//  Message.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/22/25.
//

import ErrorWrapper
import Foundation
import Supabase

struct Message: Identifiable, Hashable {
    let id: UUID
    let chatID: UUID
    let creator: UserProfile
    let receiver: UserProfile
    let message: String
    let sendedAt: Date
    
    static func query() async -> PostgrestFilterBuilder {
        await SupabaseHandler.shared.supabase
            .from("messages")
            .select(
                """
                    id,
                    chat_id,
                    message,
                    sended_at,
                    from:creator(*),
                    to:receiver(*)
                """
            )
    }
    
    init(
        id: UUID = .init(),
        chatID: UUID,
        creator: UserProfile,
        receiver: UserProfile,
        message: String,
        sendedAt: Date = .now
    ) {
        self.id = id
        self.chatID = chatID
        self.creator = creator
        self.receiver = receiver
        self.message = message
        self.sendedAt = sendedAt
    }
}

extension Message: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case chatID = "chat_id"
        case creator = "creator"
        case receiver = "receiver"
        case message = "message"
        case sendedAt = "sended_at"
        
        case from = "from"
        case to = "to"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chatID, forKey: .chatID)
        try container.encode(self.creator.id, forKey: .creator)
        try container.encode(self.receiver.id, forKey: .receiver)
        try container.encode(self.message, forKey: .message)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.chatID = try container.decode(UUID.self, forKey: .chatID)
        self.creator = try container.decode(UserProfile.self, forKey: .from)
        self.receiver = try container.decode(UserProfile.self, forKey: .to)
        self.message = try container.decode(String.self, forKey: .message)
        self.sendedAt = try container.decode(Date.self, forKey: .sendedAt)
    }
}

extension Message {
    struct DecodedMessage: Decodable {
        let id: String
        let chatID: String
        let creator: String
        let receiver: String
        let message: String
        
        func toMessage(currentUser: UserProfile, receiverUser: UserProfile) -> Message? {
            let id = UUID(uuidString: self.id)
            let chatID = UUID(uuidString: self.chatID)
            let creatorID = UUID(uuidString: self.creator)
            let receiverID = UUID(uuidString: self.receiver)
            
            if let id,
               let chatID,
               let creatorID,
               let receiverID
            {
                let userCreator = currentUser.id == creatorID ? currentUser : receiverUser
                let userReceiver = currentUser.id == receiverID ? currentUser : receiverUser
                
                let message = Message(
                    id: id,
                    chatID: chatID,
                    creator: userCreator,
                    receiver: userReceiver,
                    message: message,
                    sendedAt: .now
                )
                
                return message
            } else {
                return nil
            }
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Message.CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.chatID = try container.decode(String.self, forKey: .chatID)
            self.creator = try container.decode(String.self, forKey: .creator)
            self.receiver = try container.decode(String.self, forKey: .receiver)
            self.message = try container.decode(String.self, forKey: .message)
        }
    }
}

#if DEBUG

extension Message {
    init() {
        id = .init()
        chatID = .init()
        creator = .mock
        receiver = .mock
        message = "Hello World. \(Int.random(in: 1...1000))"
        sendedAt = .now
    }
}

#endif
