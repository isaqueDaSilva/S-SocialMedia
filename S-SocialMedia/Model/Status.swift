//
//  Status.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/21/25.
//

enum Status: Codable {
    case online, offline
    
    var displayName: String {
        switch self {
        case .online:
            "Online"
        case .offline:
            "Offline"
        }
    }
}
