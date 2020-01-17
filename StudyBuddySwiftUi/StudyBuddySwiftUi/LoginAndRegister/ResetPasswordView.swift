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
    //@ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var resetPasswordSuccessFlagForNavigation: Bool = false

    @State private var email: String = ""
    @State private var error: Bool = false
    @State private var tempAlert: Alert? = nil
    @State private var errorText: String = ""
    
    func isDataValid() -> AccountDataValidity {
        if (self.email == "" ) {
            return AccountDataValidity.invalidEmail
        } else if (!email.matches("[^@]+@[^\\.]+\\..+")) {
            return AccountDataValidity.invalidEmail
        }
        return AccountDataValidity.valid
        
    }
    
    func ResetPassword() {
        self.error = false
        if (self.isDataValid() != AccountDataValidity.valid ) {
            self.errorText = "please enter a valid Email"
        }
        else {
            self.session.resetPassword(email: email, onSuccess: {
                self.error = true
                self.resetPasswordSuccessFlagForNavigation = true
                self.tempAlert = Alert.successResetPassword
            }){
                (errorMessage) in
                print(self.error)
            }
        }
    }
    
    var body: some View {
        let emailBinding = Binding<String>(get: {
            self.email
        }, set: {
            self.email = $0
            self.errorText = self.isDataValid().rawValue
        })
        return ZStack {
            VStack {
                Group{
                    Spacer()
                    Text(FixedStringValues.appName).textStyle(StudyBuddyTitleStyleLevel1a())
                    Text("Reset Password").textStyle(StudyBuddyTitleStyleLevel1b())
                    Spacer()
                }
                VStack {
                    Text("Enter your email address").textStyle(StudyBuddyTextStyleLevel1a())
                    TextField("Email", text: emailBinding).textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                }
                Group{
                    Text(errorText).foregroundColor(.orange)
                    Button(action: {
                        self.ResetPassword()
                    }) {
                        Text("Reset Password")
                    }.buttonStyle(StudyBuddyButtonStyleLevel1())
                    // Phantom navigation link:
                    NavigationLink("", destination: LoginView(), isActive: $resetPasswordSuccessFlagForNavigation)
                }
                HStack {
                    Group{
                        Text("Don't want to reset your password?").textStyle(StudyBuddyTextStyleLevel1b())
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel").textStyle(StudyBuddyTextStyleLevel1c())
                        }
                    }
                }
                Spacer()
            }
        }.padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .edgesIgnoringSafeArea(.bottom)
            //.offset(x: 0, y: -keyboard.currentHeight)
            .animation(.easeOut(duration: 0.16))
            .alert(isPresented: $error) {
                self.tempAlert.unsafelyUnwrapped
        }
    }
}
