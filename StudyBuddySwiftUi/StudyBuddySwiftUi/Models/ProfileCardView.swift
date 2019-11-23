//
//  ProfileCardView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 23.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ProfileCardView: View {
    
    var name: String = "Your Name"
    var fieldOfStudy: String = "Field of Study"
    var description: String = "Description / Characteristics"
    var hashtags: String = "Hashes"
    
  /*  init(person: User?) {
        self.name = person?.displayName.unsafelyUnwrapped ?? "Your Name"
        self.fieldOfStudy = person?.fieldOfStudy.unsafelyUnwrapped ?? "Field of Study"
        self.description = person?.description.unsafelyUnwrapped ?? "Description / Characteristics"
        self.hashtags = person?.hashtags.unsafelyUnwrapped ?? "Hashtags"
    }*/
    
    var body: some View {
        VStack{
            Image(systemName: "person.badge.plus")
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
        }
    }
}
