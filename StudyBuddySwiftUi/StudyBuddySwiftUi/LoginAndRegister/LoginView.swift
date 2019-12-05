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
    
    @State private var showInfoMessage: Bool = false
    
    private var validated: Bool {
        !self.email.isEmpty && !self.password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                Group {
                    Image("fountainicon")
                    Text(Strings.appName).font(.largeTitle)
                        .foregroundColor(Color.white)
                }
                Spacer()
                Group {
                    Text("Enter email and password").foregroundColor(Color.white)
                    TextField("Email", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(StudyTextFieldStyle())
                }
                HStack {
                    if (self.showInfoMessage && !self.validated) {
                        Text("Empty field!").foregroundColor(.orange)
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                    }
                }
                HStack {
                    Spacer()
                    Group {
                        NavigationLink(destination: WaitForSessionUserView(email: self.email, password: self.password)) {
                            Text("Log In")
                        }.buttonStyle(StudyButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded{self.showInfoMessage.toggle()})
                        Text("or").foregroundColor(Color.white)
                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                        }.buttonStyle(StudyButtonStyle())
                    }
                }
                HStack {
                    Group {
                        Text("Forgot your password?").foregroundColor(Color.lmuLightGrey)
                        NavigationLink(destination: ResetPasswordView()) {
                            Text("Click here").foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }.navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .padding(.horizontal, 20.0)
                .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
                .offset(x: 0, y: -keyboard.currentHeight)
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



