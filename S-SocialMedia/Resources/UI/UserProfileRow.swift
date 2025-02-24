//
//  UserProfileRow.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct UserProfileRow: View {
    let profilePictureURL: URL?
    let username: String
    let text: String
    
    var body: some View {
        
        HStack(alignment: .top) {
            UserProfilePicture(url: profilePictureURL)
            
            VStack(alignment: .leading) {
                Text(username)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    init(profilePictureURL: URL? = nil, username: String, text: String) {
        self.profilePictureURL = profilePictureURL
        self.username = username
        self.text = text
    }
}

#Preview {
    UserProfileRow(profilePictureURL: nil, username: "something", text: "text")
}
