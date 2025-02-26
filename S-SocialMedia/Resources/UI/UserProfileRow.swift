//
//  UserProfileRow.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct UserProfileRow: View {
    let username: String
    let text: String
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(username)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    init(username: String, text: String) {
        self.username = username
        self.text = text
    }
}

#Preview {
    UserProfileRow(username: "something", text: "text")
}
