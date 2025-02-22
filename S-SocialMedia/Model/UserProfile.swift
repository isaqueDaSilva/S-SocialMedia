//
//  UserProfile.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//


import Foundation

struct UserProfile: Identifiable {
    let id: UUID
    var userID: UUID?
    var username: String
    var bio: String?
    var profilePictureURL: String?
    //let status: Status
    
    var pictureURL: URL? {
        if let profilePictureURL {
            return .init(string: profilePictureURL)
        } else {
            return nil
        }
    }
    
    init() {
        self.init(
            userID: nil,
            username: "",
            bio: nil,
            profilePictureURL: nil
        )
    }
    
    init(
        userID: UUID?,
        username: String,
        bio: String?,
        profilePictureURL: String?
        //status: Status
    ) {
        self.id = .init()
        self.userID = userID
        self.username = username
        self.bio = bio
        self.profilePictureURL = profilePictureURL
       // self.status = status
    }
}

extension UserProfile: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userID = "user_id"
        case username = "username"
        case bio = "bio"
        case profilePictureURL = "profile_picture_url"
        case status = "status"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.userID, forKey: .userID)
        try container.encode(self.username, forKey: .username)
        try container.encodeIfPresent(self.bio, forKey: .bio)
        try container.encodeIfPresent(self.profilePictureURL, forKey: .profilePictureURL)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.userID = nil
        self.username = try container.decode(String.self, forKey: .username)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.profilePictureURL = try container.decodeIfPresent(String.self, forKey: .profilePictureURL)
        //self.status =  try container.decode(Status.self, forKey: .status)
    }
}

extension UserProfile: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(username)
    }
}

#if DEBUG
extension UserProfile {
    static let mock = UserProfile(
        userID: .init(),
        username: "Tim Cook",
        bio: "Apple CEO",
        profilePictureURL: "https://picsum.photos/200"
    )
}
#endif
