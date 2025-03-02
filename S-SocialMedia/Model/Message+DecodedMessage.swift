//
//  Message+DecodedMessage.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 3/1/25.
//

import Foundation

extension Message {
    struct DecodedMessage {
        let id: String
        let chatID: String
        let creator: String
        let receiver: String
        let message: String
    }
}

// MARK: - Decodable handler for Decoded Message -
extension Message.DecodedMessage: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Message.CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.chatID = try container.decode(String.self, forKey: .chatID)
        self.creator = try container.decode(String.self, forKey: .creator)
        self.receiver = try container.decode(String.self, forKey: .receiver)
        self.message = try container.decode(String.self, forKey: .message)
    }
}

// MARK: - To message Handler -
extension Message.DecodedMessage {
    func toMessage(currentUser: UserProfile, receiverUser: UserProfile) -> Message? {
        guard let id = UUID(uuidString: self.id),
                  let chatID = UUID(uuidString: self.chatID),
                  let creatorID = UUID(uuidString: self.creator),
                  let receiverID = UUID(uuidString: self.receiver) else { return nil }
        
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
    }
}
