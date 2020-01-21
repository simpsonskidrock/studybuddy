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

struct LikeView: View {
    var body: some View {
        let image = Image(systemName: "hand.thumbsup.fill").resizable().foregroundColor(Color.white).frame(width: 300, height: 300, alignment: .center).shadow(radius: 10.0)
        return image
    }
}

struct DistanceView: View {
    let userModel: UserModel
    
    var body: some View {
        HStack {
            if self.userModel.distance!  >= 201.0 {
                Image(systemName: "location.slash")
                Text("no GPS")
            } else if self.userModel.distance! == 200.0 {
                Image(systemName: "location")
                Text("over 200km")
            } else if self.userModel.distance! >= 10.0 {
                Image(systemName: "location")
                Text("\(String(format: "%.0f", self.userModel.distance!))km")
            } else if self.userModel.distance! >= 1.0 {
                Image(systemName: "location")
                Text("\(String(format: "%.1f", self.userModel.distance!))km")
            } else {
                Image(systemName: "location")
                Text("\(String(format: "%.0f", self.userModel.distance!*1000))m")
            }
        }.foregroundColor(.lmuLightGrey)
    }
}
