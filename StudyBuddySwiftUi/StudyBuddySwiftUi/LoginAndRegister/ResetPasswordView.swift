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
                    Text(FixedStringValues.appName).font(.largeTitle)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("Reset Password").font(.largeTitle)
                        .foregroundColor(.lmuLightGrey)
                    Spacer()
                }
                VStack {
                    Text("Enter your email address").foregroundColor(Color.white)
                    TextField("Email", text: emailBinding).textFieldStyle(StudyTextFieldStyle())
                }
                Group{
                    Text(errorText).foregroundColor(.orange)
                    Button(action: {
                        self.ResetPassword()
                    }) {
                        Text("Reset Password")
                    }.buttonStyle(StudyButtonStyle())
                    // Phantom navigation link:
                    NavigationLink("", destination: LoginView(), isActive: $resetPasswordSuccessFlagForNavigation)
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
            }
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

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
