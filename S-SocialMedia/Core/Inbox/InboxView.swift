//
//  InboxView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct InboxView: View {
    @State private var showAddNewChat = false
    
    var body: some View {
        NavigationStack {
            List {
                ActiveNowView()
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init())
                    .listSectionSeparator(.hidden, edges: .all)
                
                ForEach(0..<10, id: \.self) { index in
                    InboxRow()
                        .listRowInsets(.init())
                }
                .padding(.top)
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddNewChat = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .sheet(isPresented: $showAddNewChat) {
                NewChatView()
            }
        }
    }
}

#Preview {
    InboxView()
}
