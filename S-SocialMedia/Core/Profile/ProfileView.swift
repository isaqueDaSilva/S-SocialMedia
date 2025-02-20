//
//  ProfileView.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/19/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var imageSetter = ImageSetter()
    
    @State private var isEditable = false
    @State private var username = "tim cook"
    @State private var bio = "Apple CEO"
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    UserProfilePicture(
                        uiImage: imageSetter.uimage,
                        size: .midSizePicture
                    )
                    
                    PhotosPicker(
                        "Edit",
                        selection: $imageSetter.pickerItemSelect
                    )
                    .disabled(!isEditable)
                }
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity)
                
                Section("Username") {
                    if isEditable {
                        TextField("Username", text: $username)
                    } else {
                        Text(username)
                    }
                }
                .listRowBackground(Color.white)
                
                Section("Bio") {
                    Group {
                        if isEditable {
                            TextField("Bio", text: $bio, axis: .vertical)
                        } else {
                            Text(bio)
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .lineLimit(5, reservesSpace: true)
                }
                .listRowBackground(Color.white)
                
                Section {
                    Button(role: .destructive) {
                        
                    } label: {
                        Text("Log out")
                    }
                    
                    Button(role: .destructive) {
                        
                    } label: {
                        Text("Delete Account")
                    }
                }
                .listRowBackground(Color.white)
            }
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGray6))
            .navigationTitle("Profile")
            .toolbar {
                Button {
                    isEditable.toggle()
                } label: {
                    Text(isEditable ? "Done" : "Edit")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
