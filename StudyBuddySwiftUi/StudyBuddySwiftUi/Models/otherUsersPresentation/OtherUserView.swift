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
            OtherUserNameView(name: userModel.displayName!, fieldOfStudy: userModel.fieldOfStudy!, description: userModel.description!, hashtags: userModel.hashtags!)
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
                    self.session.addLikedUser(uid: self.userModel.uid)
                }
            }
        }
    }
}

struct LikeView: View {
    var body: some View {
        let image = Image(systemName: "hand.thumbsup.fill").resizable().foregroundColor(Color.white).frame(width: 300, height: 300, alignment: .center).shadow(radius: 10.0)
        return image
    }
}
