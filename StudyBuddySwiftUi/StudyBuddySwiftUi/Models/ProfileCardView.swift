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
    
    init(person: User) {
        if (person.displayName != nil) { self.name = person.displayName.unsafelyUnwrapped }
        if (person.fieldOfStudy != nil) { self.fieldOfStudy = person.fieldOfStudy.unsafelyUnwrapped }
        if (person.description != nil) { self.description = person.description.unsafelyUnwrapped }
        if (person.hashtags != nil) { self.hashtags = person.hashtags.unsafelyUnwrapped }
    }
    
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
