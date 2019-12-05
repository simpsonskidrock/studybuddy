//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                Image("fountainicon")
                Text(Strings.appName).font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Enter email and password").foregroundColor(Color.white)
                TextField("Email", text: $email)
                    .textFieldStyle(StudyTextFieldStyle())

                SecureField("Password", text: $password)
                    .textFieldStyle(StudyTextFieldStyle())
                HStack {
                    Spacer()
                    NavigationLink(destination: WaitForSessionUserView(email: self.email, password: self.password)) {
                        Text("Log In")
                    }.buttonStyle(StudyButtonStyle())
                    Text("or").foregroundColor(Color.white)
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())
                }
                HStack {
                    Text("Forgot your password?").foregroundColor(Color.lmuLightGrey)
                    NavigationLink(destination: ResetPasswordView()) {
                        Text("Click here").foregroundColor(.white)
                    }
                }
                Spacer()
            }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .padding(.horizontal, 20.0)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
    struct GeometryGetter: View {
        @Binding var rect: CGRect
        var body: some View {
            GeometryReader { geometry in
                Group { () -> AnyView in
                    DispatchQueue.main.async {
                        self.rect = geometry.frame(in: .global)
                    }
                    return AnyView(Color.clear)
                }
            }
        }
    }
}



