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
    
    @State var loading = false
    @State var error = false
    @State var tempAlert: Alert = nil
    
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var repeatNewPassword: String = ""
    
    func changePassword() {
        self.loading = true
        self.error = false
        if (self.email == "" || self.newPassword == "" || self.repeatNewPassword == "") {
            self.error = true
            self.tempAlert = Alert.alertEmptyField
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
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    SecureField("Confirm New Password", text: $repeatNewPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                }
                NavigationLink(destination: GeneralTabView()) {
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
