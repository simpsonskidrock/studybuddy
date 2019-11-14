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
    @State var usernameText = ""
    @State var passwordText = ""
    
    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            Image("fountainicon")
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
            Spacer()
            Text("Enter username or password").foregroundColor(Color.white)
            
            CustomTextField(
                placeholder: Text("username").foregroundColor(.lmuLightGrey),
                text: $usernameText
            ).padding(.horizontal)
            CustomTextField(
                placeholder: Text("password").foregroundColor(.lmuLightGrey),
                text: $passwordText
            ).padding(.horizontal)
                
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    self.loggedIn.toggle()
                }) {
                    Text("Log In")
                }.sheet(isPresented: $loggedIn) {
                    GeneralTabView()
                }
                Spacer()
                Text("or").foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    self.isRegistered.toggle()
                }) {
                    Text("Register")
                }.sheet(isPresented: $isRegistered) {
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
