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
    @State private var repeatPassword: String = "Confirm password"

    
    var body: some View {
        VStack(spacing: 16) {
            Text("Sign Up").font(.largeTitle).foregroundColor(.lmuLightGrey)
            Spacer()
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
            HStack {
                Image(systemName: "person.badge.plus")
                .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 5)
                )
                
            }
            
            Text("Create a new Account").foregroundColor(Color.white)
            
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

