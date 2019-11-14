//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var loggedIn = false
    @State var isRegistered = false
    @State var username = "username"
    @State var password = "password"
    @State var name: String = "John"
    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            Image("fountainicon")
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
            Spacer()
            Text("Enter username or password").foregroundColor(Color.white)
            
            
            TextField("", text: $username)
            .textFieldStyle(StudyTextFieldStyle())
            .padding(.horizontal, 50)
            SecureField("", text: $password)
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
            Spacer()
        }
        .padding(.horizontal, 20.0)
        .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
        
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
