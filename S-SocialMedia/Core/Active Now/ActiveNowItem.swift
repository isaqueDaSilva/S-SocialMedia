//
//  ActiveNowItem.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI

struct ActiveNowItem: View {
    var body: some View {
        VStack {
            UserProfilePicture()
                .overlay {
                    Circle()
                        .fill(.green)
                        .frame(width: 15, height: 15)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.trailing, 1)
                        .padding(.bottom, 2)
                    
                }
            
            Text("Tim Cook")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ActiveNowItem()
}
