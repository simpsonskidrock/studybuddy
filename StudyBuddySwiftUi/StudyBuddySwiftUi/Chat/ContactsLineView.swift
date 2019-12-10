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
            self.image = UIImage()
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
                Spacer()
                UserNameView(name: name)
               
                NavigationLink(destination: ChatView()){
                    Spacer()
                    Text("Match").foregroundColor(.red).font(.system(size: 12))

                }
            } else {
                ImageView(image: image)
                UserNameView(name: name)
                Spacer()
                Text("Liked").font(.system(size: 12))
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
            .clipShape(Circle())
            .frame(width: 80, height: 80)
            .overlay(
                Circle().stroke(Color.white,lineWidth: 1)
                    
        )
    }
}

struct UserNameView: View {
    let name: String
    
    var body: some View {
        Text("\(name)")
            .fontWeight(.regular)
    }
}
