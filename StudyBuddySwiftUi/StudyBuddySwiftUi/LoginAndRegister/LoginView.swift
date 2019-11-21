//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    
    @EnvironmentObject var session: SessionStore
    @State private var showingMessageAlert = false
    func getUser () {
        session.listen()
    }
    
    
    
    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    
    
    var body: some View {
        NavigationView {
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
                HStack {
                    Spacer()
                    NavigationLink(destination: GeneralTabView()) {
                        Text("Log In")
                    }.buttonStyle(StudyButtonStyle())                 .simultaneousGesture(TapGesture().onEnded{self.signIn()})
                    Text("or").foregroundColor(Color.white)
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())
                    
                }
                HStack {
                    Text("Forgot your password?").foregroundColor(Color.lmuLightGrey)
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Click here").foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .onAppear(perform: getUser)
            .padding(.horizontal, 20.0).background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .alert(isPresented: $error) {
                Alert(title: Text("Error"), message: Text("Please enter a valid Email and Password"), dismissButton: .default(Text("OK")))
            }
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

