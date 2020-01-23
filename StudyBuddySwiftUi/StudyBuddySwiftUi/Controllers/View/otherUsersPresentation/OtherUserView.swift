//
//  OtherUserView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct OtherUserView: View {
    @EnvironmentObject var session: SessionStore
    @State private var showText = false
    let userModel: UserModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            OtherUserAvatarView(userModel: userModel)
            OtherUserNameView(name: userModel.displayName, fieldOfStudy: userModel.fieldOfStudy, description: userModel.description, hashtags: userModel.getHashtagsAsString())
            if self.session.searchWithGPS {
                VStack {
                    HStack {
                        Spacer()
                        DistanceView(userModel: self.userModel)
                    }
                    Spacer()
                }
            }
            if showText {
                HStack {
                    Spacer()
                    LikeView()
                    Spacer()
                }
                Spacer()
            }
        }
        .shadow(radius: 12.0)
        .cornerRadius(12.0)
        .onTapGesture(count: 2) {
            withAnimation(.easeInOut(duration: 1.0)){
                self.showText.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 2.0)){self.showText.toggle()}
                    self.session.addLikedUser(user: self.userModel)
                }
            }
        }
    }
}
