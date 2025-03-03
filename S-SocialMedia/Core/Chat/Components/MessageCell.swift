//
//  MessageCell.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/20/25.
//

import SwiftUI

struct MessageCell: View {
    let isFromCurrentUser: Bool
    let message: String
    
    @State private var showFullMessage = false
    
    private var isLineLimit: Bool {
        message.count > 328
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .lineLimit(showFullMessage ? nil : 10)
            
            Group {
                if isLineLimit {
                    Button {
                        withAnimation(.easeInOut) {
                            showFullMessage.toggle()
                        }
                    } label: {
                        Text("Read \(showFullMessage ? "Less" : "More")")
                            .font(.subheadline)
                            .foregroundStyle(
                                isFromCurrentUser ? Color.primary : .blue
                            )
                    }
                }
            }
        }
        .padding(12)
        .foregroundStyle(isFromCurrentUser ? .white : .primary)
        .background {
            ChatBubble(isFromAuthenticatedUser: isFromCurrentUser)
                .fill(
                    isFromCurrentUser ? Color(uiColor: .systemBlue) : .secondary.opacity(0.7)
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment: isFromCurrentUser ? .trailing : .leading
        )
        .padding(isFromCurrentUser ? .leading : .trailing, 100)
    }
}

#Preview {
    VStack {
        MessageCell(
            isFromCurrentUser: true,
            message: "Yes, he is the best CEO of any company today,Yes, he is the best CEO of any company today, Yes, he is the best CEO of any company today Yes, he is the best CEO of any company today,Yes, he is the best CEO of any company today, Yes, he is the best CEO of any company today, Yes, I'm Tim Cook, Apple CEO, Basketball lover, Sells m"
        )
        
        MessageCell(
            isFromCurrentUser: false,
            message: "Yes, he is the best CEO of any company today,Yes, he is the best CEO of any company today, Yes, he is the best CEO of any company today Yes, he is the best CEO of any company today,Yes, he is the best CEO of any company today, Yes, he is the best CEO of any company today, Yes, I'm Tim Cook, Apple CEO, Basketball lover, Sells man man mnnmmjjj"
        )
        
        MessageCell(isFromCurrentUser: true, message: "I'm Tim Cook")
    }
    .padding(.horizontal)
}
