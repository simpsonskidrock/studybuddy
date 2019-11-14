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
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            Image("fountainicon")
            Text("StudyBuddy")
            Spacer()
            Text("Enter username or password")
            TextField("username", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
            TextField("password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
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
                Text("or")
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
