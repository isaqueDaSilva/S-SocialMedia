//
//  InboxRow.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct InboxRow: View {
    let username: String
    let message: String
    let sendedAt: Date?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            UserProfileRow(
                username: username,
                text: message
            )
            
            Text(
                sendedAt ?? .now,
                format: .dateTime.day().month().weekday().hour().minute()
            )
            .font(.footnote)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .frame(height: 72)
    }
}

#Preview {
    InboxRow(username: "something", message: "text", sendedAt: .now)
    
}
