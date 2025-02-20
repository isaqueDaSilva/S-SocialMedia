//
//  UserProfileRow.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct UserProfileRow: View {
    var body: some View {
        HStack {
            UserProfilePicture()
            
            VStack(alignment: .leading) {
                Text("Tim Cook")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Today we’re proud to announce the newest member of the iPhone 16 family, iPhone 16e, our most affordable model yet.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .padding(.trailing, 10)
            }
        }
    }
}

#Preview {
    UserProfileRow()
}
