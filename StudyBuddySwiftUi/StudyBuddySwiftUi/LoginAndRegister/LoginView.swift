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
    
    @State var email = ""
    @State var password = ""
    @State private var showingMessageAlert = false
    
    
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
                
                HStack(spacing: 8) {
                    Spacer()
                    
                    NavigationLink(destination: GeneralTabView()) {
                        Text("Log In")
                    }.buttonStyle(StudyButtonStyle())
                    
                    Spacer()
                    Text("or").foregroundColor(Color.white)
                    Spacer()
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())
                    
                    Spacer()
                }
                HStack {
                    Text("Forgot your password?").foregroundColor(Color.lmuLightGrey)
                    
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Click here").foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20.0)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .alert(isPresented: $showingMessageAlert) {
                
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
