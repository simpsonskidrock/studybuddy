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
    @State var loggedOut = false
    @State var editProfile = false
    
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
                    self.loggedOut.toggle() 
                    
                }){
                  
                        HStack {
                            Image(systemName: "arrow.uturn.left")
                                .font(.system(size: 20))
                            Text("Logout")
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                        }
                    }
                .sheet(isPresented: $loggedOut) {
                        LoginView()
                }.foregroundColor(.lmuLightGrey)
                     .padding()
                    
                    
                    
               
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
                
                Text("Your Name")
                    .foregroundColor(.black)
                    
                    .fontWeight(.semibold)
                Text("Field of Study")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                VStack{
                    
                    ScrollView(.vertical) {
                        
                        Text("Description / Characteristics").foregroundColor(.black)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    ScrollView(.vertical) {
                        
                        Text("Hashtags").foregroundColor(.black)
                    }
                }
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
                    }
                .foregroundColor(.lmuLightGrey)
           
        } .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .navigationBarTitle("Profil")
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
