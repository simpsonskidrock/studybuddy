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
    
    @State private var loading = false
    @State private var error = false
    
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var repeatNewPassword: String = ""
    
    private func changePassword() {
        self.loading = true
        self.error = false
        if (self.email == "" || self.newPassword == "" || self.repeatNewPassword == "") {
            self.error = true
        } else if (self.newPassword.count < 6 || self.repeatNewPassword.count < 6) {
            self.error = true
        } else if (self.newPassword != self.repeatNewPassword) {
            self.error = true
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
                Spacer()
                Text(FixedStringValues.appName).textStyle(StudyBuddyTitleStyleLevel1a())
                Text("Change Password").textStyle(StudyBuddyTitleStyleLevel1b())
                Spacer()
                VStack {
                    Text("Enter new password").textStyle(StudyBuddyTextStyleLevel1a())
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                    SecureField("Confirm New Password", text: $repeatNewPassword)
                        .textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                }
                NavigationLink(destination: ProfileTabView()) {
                    Text("Change Password").font(.system(size: 20))
                        .fontWeight(.heavy)
                }.buttonStyle(StudyBuddyButtonStyleLevel1())
                    .simultaneousGesture(TapGesture().onEnded{self.changePassword()})
                HStack {
                    Text("Don't want to change your password?").textStyle(StudyBuddyTextStyleLevel1b())
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel").textStyle(StudyBuddyTextStyleLevel1c())
                    }
                }
                Spacer()
            }
            .padding(.horizontal) .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
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
