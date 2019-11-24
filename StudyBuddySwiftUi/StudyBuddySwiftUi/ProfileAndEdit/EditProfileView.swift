//
//  EditProfileView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var mode
    @State var displayName = ""
    @State var fieldOfStudy = ""
    @State var description = ""
    @State var hashtags = ""
    
    var body: some View {
        VStack{
            HStack{
                Text("Edit profile")
                    .foregroundColor(.lmuLightGrey)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                Spacer()
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }){
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                }.foregroundColor(.lmuLightGrey)
                    .padding()
            }.frame(height: 50)
                .padding(.leading, 10)
            VStack{ Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .colorInvert()
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 150, height: 150))
                    .padding(.vertical, 35)
                Spacer()
                HStack{
                    Text("Name:")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextField("Enter your name", text:  $displayName)
                }
                HStack{
                    Text("Field Of Study")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextField("ex: Informatik", text:  $fieldOfStudy)
                }
                VStack{
                    Text("Description")
                        .foregroundColor(.black)
                    TextField("Describe your self", text: $description)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                    
                    Text("Hashtags").foregroundColor(.black)
                    TextField("#", text: $hashtags).lineLimit(nil)
                }
            }
            Button(action: {
                // todo saving
                self.mode.wrappedValue.dismiss()
            }) {
                Text("Save").fontWeight(.semibold).font(.system(size: 20))
            }.padding().foregroundColor(.lmuLightGrey)
            Spacer()
        } .padding(.horizontal) .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .navigationBarTitle("Profil")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
