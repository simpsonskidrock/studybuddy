//
//  ChangePasswordView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject private var keyboard = KeyboardResponder()

    @State var registered = false
    @State var goToLogin = false
    
    @State private var email: String = ""
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var repeatNewPassword: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Change Password").font(.largeTitle).foregroundColor(.lmuLightGrey)
                Spacer()
            Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                Spacer()
                VStack {
                    Text("Enter new password").foregroundColor(Color.white)
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    TextField("Old Password", text: $oldPassword)
                    .textFieldStyle(StudyTextFieldStyle())
                    .padding(.horizontal, 50)
                    TextField("New Password", text: $newPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    TextField("Confirm New Password", text: $repeatNewPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                }
                Button(action: {
                    self.registered.toggle()
                }) {
                    Text("Change Password")
                        .font(.system(size: 20))
                        .fontWeight(.heavy)
                }.buttonStyle(StudyButtonStyle())
                    .sheet(isPresented: $registered) {
                        GeneralTabView()
                }
                HStack {
                    Text("Don't want to change your password?").foregroundColor(Color.lmuLightGrey)
                    
                    Button(action: {
                        self.goToLogin.toggle()
                    }) {
                        Text("Cancel") .foregroundColor(.white)
                    }.sheet(isPresented: $goToLogin) {
                        LoginView()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
        }
    }
    
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
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
