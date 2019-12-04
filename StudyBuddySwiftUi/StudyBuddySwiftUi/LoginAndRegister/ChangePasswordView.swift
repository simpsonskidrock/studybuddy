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
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var loading = false
    @State private var error = false
    @State private var tempAlert: Alert = nil
    
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var repeatNewPassword: String = ""
    
    private func changePassword() {
        self.loading = true
        self.error = false
        if (self.email == "" || self.newPassword == "" || self.repeatNewPassword == "") {
            self.error = true
            self.tempAlert = Alert.alertEmptyField
        } else if (self.newPassword.count < 6 || self.repeatNewPassword.count < 6) {
            self.error = true
            self.tempAlert = Alert.alertTooShortPassword
        } else if (self.newPassword != self.repeatNewPassword) {
            self.error = true
            self.tempAlert = Alert.alertUnequalPassword
        } else {
            //todo password change and not creating a new user
            /* session.signUp(email: email, password: newPassword) {(result, error_FieldIsEmpty) in self.loading = false
                if error_FieldIsEmpty != nil {
                    print("Error")
                    self.error_FieldIsEmpty = true
                }
                else { */
                    self.email = ""
                    self.newPassword = ""
               // }
        //    }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Change Password").font(.largeTitle).foregroundColor(.lmuLightGrey)
                Spacer()
                Text(Strings.appName).font(.largeTitle).foregroundColor(Color.white)
                Spacer()
                VStack {
                    Text("Enter new password").foregroundColor(Color.white)
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("Confirm New Password", text: $repeatNewPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                }
                NavigationLink(destination: ProfileTabView()) {
                    Text("Change Password").font(.system(size: 20))
                        .fontWeight(.heavy)
                }.buttonStyle(StudyButtonStyle()).simultaneousGesture(TapGesture().onEnded{self.changePassword()})
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
            .padding(.horizontal) .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .alert(isPresented: $error) {
                self.tempAlert.unsafelyUnwrapped
            }
            .navigationBarTitle("")
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
    
}
