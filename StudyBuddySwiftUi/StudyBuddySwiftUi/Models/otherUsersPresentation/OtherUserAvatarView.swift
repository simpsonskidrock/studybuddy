//
//  OtherUserAvatarView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct OtherUserAvatarView: View {
    @EnvironmentObject var session: CommunicationStore
    @State var image: UIImage = UIImage()
    private var userModel: UserModel

    func initialize() {
        if (userModel.profileImageUrl != nil) {
            self.session.getProfileImage(profileImageUrl: userModel.profileImageUrl!, handler: { image in
                self.image = image
            })
        }
    }

    init(userModel: UserModel) {
        self.userModel = userModel
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

    var body: some View {
        Group {
            Image(uiImage: image)
                .resizable()
                .frame(width: 300, height: 400)
                .scaledToFit()
                .overlay(
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                            startPoint: .center, endPoint: .bottom))
                        .clipped()
                )
                .cornerRadius(12.0)
        }.onAppear(perform: initialize)
    }
}
