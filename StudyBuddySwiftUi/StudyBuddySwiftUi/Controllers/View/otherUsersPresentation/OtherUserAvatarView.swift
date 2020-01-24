//
//  OtherUserAvatarView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct OtherUserAvatarView: View {
    @EnvironmentObject var session: SessionStore
    @State var image: UIImage = UIImage()
    let userModel: UserModel

    func initialize() {
        self.session.getProfileImage(profileImageUrl: userModel.profileImageUrl, handler: { image in
            self.image = image
        })
    }
    
    var body: some View {
        HStack {
            Spacer()
            Image(uiImage: image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                //.scaledToFit()
                //.frame(width: 300, height: 400)
                //.aspectRatio(contentMode: .fit)
                //.aspectRatio(CGSize(width: 300, height: 400), contentMode: .fill)
                
                
            Spacer()
        }.frame(width: 350, height: nil)
            .overlay(
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                                         startPoint: .center, endPoint: .bottom))
                    .clipped()
        )
            .cornerRadius(12.0)
        .onAppear(perform: initialize)
    }
}
