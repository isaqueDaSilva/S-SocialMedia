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
    let sentAt: Date
    
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
        self.sentAt = sendedAt
    }
}

// MARK: - Static Query -

extension Message {
    static func query() async -> PostgrestFilterBuilder {
        SupabaseHandler.shared.supabase
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
}

// MARK: - Codable Methods -
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
        self.sentAt = try container.decode(Date.self, forKey: .sendedAt)
    }
}

// MARK: - Mock Data -
#if DEBUG
extension Message {
    init() {
        id = .init()
        chatID = .init()
        creator = .mock
        receiver = .mock
        message = "Hello World. \(Int.random(in: 1...1000))"
        sentAt = .now
    }
}
#endif
