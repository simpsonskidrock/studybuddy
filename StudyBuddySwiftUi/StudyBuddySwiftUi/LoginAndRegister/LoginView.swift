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
    @State var email = ""
    @State var password = ""
    @State var name: String = "John"
    @State private var showingMessageAlert = false
    

    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            Image("fountainicon")
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
            Spacer()
            Text("Enter email and password").foregroundColor(Color.white)
            
            
            TextField("Email", text: $email)
            .textFieldStyle(StudyTextFieldStyle())
            .padding(.horizontal, 50)
            SecureField("Password", text: $password)
            .textFieldStyle(StudyTextFieldStyle())
                .padding(.horizontal, 50)
            
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    if (self.password.count == 0 || self.email.count == 0){
                                 
                                  self.showingMessageAlert = true
                              } else {
                                  self.loggedIn.toggle()

                              }
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
            
        .alert(isPresented: $showingMessageAlert) {
            
            Alert(title: Text("Error"), message: Text("Please enter a valid Email and Password"), dismissButton: .default(Text("OK")))
            
        }
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
    
 
}
