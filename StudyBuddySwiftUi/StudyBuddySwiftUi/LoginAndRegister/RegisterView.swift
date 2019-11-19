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
    @State var registered = false
    @State var goToLogin = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                Text("Sign Up").font(.largeTitle).foregroundColor(.lmuLightGrey)
                Spacer()
                Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 100, height: 100.0)
                    .colorInvert()
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 150, height: 150))
                    .padding(.vertical, 35)
                VStack {
                    Text("Create a new Account").foregroundColor(Color.white)
                    
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    TextField("Password", text: $password)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    TextField("Confirm Password", text: $repeatPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                }
                Button(action: {
                    self.registered.toggle()
                }) {
                    Text("Register")
                        .font(.system(size: 20))
                        .fontWeight(.heavy)
                }.buttonStyle(StudyButtonStyle())
                    .sheet(isPresented: $registered) {
                        GeneralTabView()
                }
                HStack {
                    Text("Already have an account?").foregroundColor(Color.lmuLightGrey)
                    
                    Button(action: {
                        self.goToLogin.toggle()
                    }) {
                        Text("Sign In") .foregroundColor(.white)
                    }.sheet(isPresented: $goToLogin) {
                        
                        LoginView()
                    }
                    
                }
                
                
                
                Spacer()
                
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
