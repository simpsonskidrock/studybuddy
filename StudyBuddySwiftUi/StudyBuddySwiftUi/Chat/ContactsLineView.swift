//
//  ContactsLineView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 10.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ContactsLineView: View {
    @EnvironmentObject var session: SessionStore
    
    var uid: String
    var chatAllowed: Bool
    
    @State var name: String = ""
    @State var image: UIImage = UIImage()
    
    func getImage(path: String) {
        if (!path.isEmpty) {
            self.session.getProfileImage(profileImageUrl: path, handler: { image in
                self.image = image
            })
        } else {
            self.image = UIImage(systemName: "person")!
        }
    }
    
    func initialize() {
        self.session.getProfile(uid: uid, handler: { user in
            self.name = user.displayName!
            self.getImage(path: user.profileImageUrl!)
        })
    }
    
    var body : some View {
        HStack {
            if chatAllowed {
                ImageView(image: image)
                UserNameView(name: uid)
                Spacer()
                NavigationLink(destination: ChatView()){
                    Text("Match")
                }
            } else {
                ImageView(image: image)
                UserNameView(name: uid)
                Spacer()
                Text("Like")
            }
        }.onAppear(perform: initialize)
    }
}

struct ImageView: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .overlay(
                Circle()
                    .clipped()
        )
    }
}

struct UserNameView: View {
    let name: String
    
    var body: some View {
        Text("\(name)")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(.white)
    }
}
