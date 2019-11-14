//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State var loggedIn = false
    @State private var username: String = "username"
    @State private var password: String = "password"
    @State private var repeatPassword: String = "repeat password"

    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
            Spacer()
            
            Text("Enter username or password").foregroundColor(Color.white)
            
            TextField("", text: $username)
            .textFieldStyle(StudyTextFieldStyle())
            .padding(.horizontal, 50)
            TextField("", text: $password)
            .textFieldStyle(StudyTextFieldStyle())
            .padding(.horizontal, 50)
            TextField("", text: $repeatPassword)
            .textFieldStyle(StudyTextFieldStyle())
            .padding(.horizontal, 50)

            
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    self.loggedIn.toggle()
                }) {
                    Text("Register")
                }.buttonStyle(StudyButtonStyle())
                    .sheet(isPresented: $loggedIn) {
                    GeneralTabView()
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 20.0)
        .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

