//
//  OtherUserView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct OtherUserView: View {
    @EnvironmentObject var session: CommunicationStore
    @State private var showText = false
    let userModel: UserModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            OtherUserAvatarView(userModel: userModel)
            OtherUserNameView(name: userModel.displayName!, fieldOfStudy: userModel.fieldOfStudy!, description: userModel.description!, hashtags: userModel.hashtags!)
            if showText {
                LikeView()
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
    /*
     var body: some View{
     Text("Like").background(Color.lmuGreen).cornerRadius(10.0).foregroundColor(Color.white).font(.largeTitle)
     }
     */
    var body: some View{
        
        let image = Image(systemName: "hand.thumbsup.fill").foregroundColor(Color.white)
        return image
    }
}
