//
//  ChatHeaderView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 20.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatHeaderView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var uid: String
    @State var name: String = ""
    @State var image: UIImage = UIImage()
    
    func initialize() {
        self.session.getProfile(uid: uid, handler: { user in
            self.name = user.displayName
            self.getImage(path: user.profileImageUrl)
        })
    }
    
    func getImage(path: String) {
        if (!path.isEmpty) {
            self.session.getProfileImage(profileImageUrl: path, handler: { image in
                self.image = image
            })
        } else {
            self.image = UIImage(systemName: "person")!
        }
    }
    
    var body : some View {
        HStack {
            ChatImageView(image: image)
            ChatUserNameView(name: name)
            Spacer()
        }.onAppear(perform: initialize)
    }
}

struct ChatImageView: View {
    let image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width:60, height: 60)
    }
}

struct ChatUserNameView: View {
    let name: String
    var body: some View {
        Text("\(name)")
            .bold()
            .font(Font.system(size: 30))
    }
}
