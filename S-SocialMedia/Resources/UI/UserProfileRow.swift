//
//  UserProfileRow.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct UserProfileRow: View {
    let user: UserProfile
    
    var body: some View {
        HStack {
            UserProfilePicture(url: user.pictureURL)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(user.bio ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .padding(.trailing, 10)
            }
        }
    }
}

#Preview {
    UserProfileRow(user: .mock)
}
