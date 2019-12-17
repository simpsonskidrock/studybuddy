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
            Text("Like")
                .background(Color.lmuDarkGrey)
                .cornerRadius(10.0)
                .foregroundColor(Color.white)
                .font(.largeTitle)
                
                
                    }
        
        }
        .shadow(radius: 12.0)
        .cornerRadius(12.0)
        .onTapGesture(count: 2) {
            self.session.addLikedUser(uid: self.userModel.uid)
            
            withAnimation(.spring()){
            self.showText.toggle()
            }
            
            }
        }
    }

