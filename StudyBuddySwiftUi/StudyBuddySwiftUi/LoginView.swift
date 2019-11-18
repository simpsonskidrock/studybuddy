//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var loggedIn = false
    @State var forgotpassword = false

    @State var isRegistered = false
    @State var username = ""
    @State var password = ""
    @State var name: String = "John"
    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            Image("fountainicon")
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
            Spacer()
            Text("Enter username and password").foregroundColor(Color.white)
            
            
            TextField("Username", text: $username)
            .textFieldStyle(StudyTextFieldStyle())
            .padding(.horizontal, 50)
            SecureField("Password", text: $password)
            .textFieldStyle(StudyTextFieldStyle())
                .padding(.horizontal, 50)
            
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    self.loggedIn.toggle()
                }) {
                    Text("Log In")
                }.buttonStyle(StudyButtonStyle())
                    .sheet(isPresented: $loggedIn) {
                        GeneralTabView()
                }
                Spacer()
                Text("or").foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    self.isRegistered.toggle()
                }) {
                    Text("Register")
                }.buttonStyle(StudyButtonStyle())
                    .sheet(isPresented: $isRegistered) {
                        RegisterView()
                }
                Spacer()
            }
          HStack {
                  Text("Forgot your password?").foregroundColor(Color.lmuLightGrey)
                  
                            Button(action: {
                                self.forgotpassword.toggle()
                            }) {
                              Text("Click here") .foregroundColor(.white)
                            }.sheet(isPresented: $forgotpassword) {
                                    ChangePasswordView()
                            }
                            }
            
        }
        .padding(.horizontal, 20.0)
        .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
