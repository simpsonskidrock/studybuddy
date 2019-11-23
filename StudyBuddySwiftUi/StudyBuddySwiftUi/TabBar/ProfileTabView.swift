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
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var mode
    @State var editProfile = false
   
    func getUser () {
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
                ProfileCardView().scaledToFit()
            }
            Button(action: {
                self.editProfile.toggle()
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                    Text("Edit Profile")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                }
            }
            .sheet(isPresented: $editProfile) {
                EditProfileView()
                Spacer()
            }
            .foregroundColor(.lmuLightGrey)
        } .padding(.horizontal) .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical)) .navigationBarHidden(true).navigationBarBackButtonHidden(true)
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
