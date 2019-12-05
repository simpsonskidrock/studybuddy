//
//  ResetPasswordView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 01.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()

    
    @State private var email: String = ""
    @State private var error: Bool = false
    @State private var tempAlert: Alert = nil
    
    private func ResetPassword() {
        self.error = false
        if (self.email == "" ) {
            self.error = true
            self.tempAlert = Alert.alertEmptyField
        }
        else {
            self.session.resetPassword(email: email, onSuccess: {
                self.error = true
                self.tempAlert = Alert.alertSuccessResetPassword
                
            }){
                (errorMessage) in
                print(self.error)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Group{
                Text(Strings.appName).font(.largeTitle).foregroundColor(Color.white)
                Spacer()
                Text("Reset Password").font(.largeTitle).foregroundColor(.lmuLightGrey)
                Spacer()
                VStack {
                    Text("Enter your email address").foregroundColor(Color.white)
                    TextField("Email", text: $email).textFieldStyle(StudyTextFieldStyle())
                }
                }
                Group{
                NavigationLink(destination: LoginView()) {
                    Text("Reset Password")
                }.buttonStyle(StudyButtonStyle())
                    .simultaneousGesture(TapGesture()
                    .onEnded{
                        self.ResetPassword()
                        
                })
                }
                HStack {
                    Group{
                    Text("Don't want to reset your password?").foregroundColor(Color.lmuLightGrey)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel").foregroundColor(.white)
                    }
                    }
                }
                Spacer()
            }.padding(.horizontal)
                .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: 0, y: -keyboard.currentHeight)
                .animation(.easeOut(duration: 0.16))
                .alert(isPresented: $error) {
                    self.tempAlert.unsafelyUnwrapped
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
