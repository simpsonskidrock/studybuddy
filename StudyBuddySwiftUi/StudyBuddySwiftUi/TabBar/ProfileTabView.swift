//
//  ProfileTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileTabView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    
    @State var displayName = ""
    @State var fieldOfStudy = ""
    @State var description = ""
    @State var hashtags = ""
    
    @State private var editProfile = false
    
    func getProfile() -> User {
        return session.sessionUser.unsafelyUnwrapped
    }
    
    func getSession() {
        session.listen()
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("Profile")
                    .foregroundColor(.lmuLightGrey)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                Spacer()
                Button(action: {
                    self.session.signOut()
                    self.mode.wrappedValue.dismiss()
                }){
                    HStack {
                        Image(systemName: "arrow.uturn.left")
                            .font(.system(size: 20))
                        Text("Logout")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                    }.foregroundColor(.lmuLightGrey)
                }.padding()
            }.frame(height: 50)
                .padding(.leading, 10)
            VStack{
                Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .colorInvert()
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 150, height: 150))
                    .padding(.vertical, 35)
                HStack{
                    Text("Name:")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextField("Enter your name", text:  $displayName)
                        .disableAutocorrection(true)
                        .disabled(!self.editProfile)
                        .foregroundColor(.lmuLightGrey)
                }
                HStack{
                    Text("Field Of Study:")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextField("ex: Informatik", text:  $fieldOfStudy).disabled(!self.editProfile)
                        .foregroundColor(.lmuLightGrey)
                }
                VStack{
                    Text("Description")
                        .foregroundColor(.black)
                    TextField("Describe your self", text: $description)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(5)
                        .disabled(!self.editProfile)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.lmuLightGrey)
                    
                    Text("Hashtags").foregroundColor(.black)
                    TextField("#", text: $hashtags).lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .disabled(!self.editProfile)
                        .foregroundColor(.lmuLightGrey)
                }
            }
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    self.editProfile.toggle()
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 20))
                        Text("Edit")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                    }
                }.disabled(self.editProfile)
                    .foregroundColor(.lmuLightGrey)
                Spacer()
                Button(action: {
                    // todo saving
                    self.editProfile.toggle()
                }) {
                    HStack {
                        Text("Save").fontWeight(.semibold).font(.system(size: 20))
                    }
                }.padding().foregroundColor(.lmuLightGrey)
                    .disabled(!self.editProfile)
                Spacer()
                
            }
        }.onAppear(perform: getSession)
            .padding(.horizontal) .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical)) .navigationBarHidden(true).navigationBarBackButtonHidden(true)
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
