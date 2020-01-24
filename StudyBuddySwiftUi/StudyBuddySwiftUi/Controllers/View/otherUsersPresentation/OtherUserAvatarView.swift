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
                .scaledToFit()
                .overlay(
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                                             startPoint: .center, endPoint: .bottom))
                        .clipped()
            )
                .cornerRadius(12.0)
            Spacer()
        }.onAppear(perform: initialize)
    }
}
