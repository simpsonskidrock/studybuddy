//
//  ProfileCardView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 23.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ProfileCardView: View {
    var name: String = ""
    var fieldOfStudy: String = ""
    var description: String = ""
    var hashtags: String = ""
    var profileImage: UIImage = UIImage()
    
    init(user: User) { //, profileImage: UIImage) {
        if (user.displayName != nil) { self.name = user.displayName! }
        if (user.fieldOfStudy != nil) { self.fieldOfStudy = user.fieldOfStudy! }
        if (user.description != nil) { self.description = user.description! }
        if (user.hashtags != nil) { self.hashtags = user.hashtags! }
        //self.profileImage = profileImage
    }
    
    var body: some View {
        VStack {
            Image(uiImage: self.profileImage)
                .resizable()
                .frame(width: 90, height: 90)
                .colorInvert()
                .overlay(Circle()
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: 150, height: 150))
                .padding(.vertical, 35)
            Text(self.name)
                .foregroundColor(.black)
                .fontWeight(.semibold)
            Text(self.fieldOfStudy)
                .foregroundColor(.black)
                .fontWeight(.semibold)
            VStack{
                ScrollView(.vertical) {
                    Text(self.description).foregroundColor(.black)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                }
                ScrollView(.vertical) {
                    Text(self.hashtags).foregroundColor(.black)
                }
            }
        }.shadow(radius: 12.0)
        .cornerRadius(12.0)
    }
}
