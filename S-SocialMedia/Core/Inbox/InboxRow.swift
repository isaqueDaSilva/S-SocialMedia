//
//  InboxRow.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct InboxRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            UserProfileRow()
            
            HStack {
                Text("Yesterday")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.gray)
            
        }
        .frame(height: 72)
        .padding(.horizontal, 15)
    }
}

#Preview {
    InboxRow()
    
}
