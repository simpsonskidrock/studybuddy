//
//  ChangePasswordView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var mode
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var email: String = ""
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
                    TextField("New Password", text: $newPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    TextField("Confirm New Password", text: $repeatNewPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                }
                NavigationLink(destination: GeneralTabView()) {
                    Text("Change Password").font(.system(size: 20))
                        .fontWeight(.heavy)
                }.buttonStyle(StudyButtonStyle())
                
                HStack {
                    Text("Don't want to change your password?").foregroundColor(Color.lmuLightGrey)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel") .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            
        }.navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
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
