//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

struct RegisterView: View {
    @Environment(\.presentationMode)
    var mode
    @EnvironmentObject var session: SessionStore
    //@ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var signUpSuccessFlagForNavigation: Bool = false
    @State private var errorText: String = ""
    
    @State private var errorDialogVisible: Bool = false
    @State private var tempAlert: Alert? = nil
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    func isDataValid() -> AccountDataValidity {
        if (self.email == "" || self.password == "" || self.repeatPassword == "") {
            return AccountDataValidity.invalidEmail
        } else if (!email.matches("[^@]+@[^\\.]+\\..+")) {
            return AccountDataValidity.invalidEmail
        } else if (self.password.count < 6) {
            return AccountDataValidity.shortPassword
        } else if (self.password != self.repeatPassword) {
            return AccountDataValidity.unequalPasswords
        }
        return AccountDataValidity.valid
    }

    /**
        Starts the register process if the data is valid.
    */
    func signUpAction() {
        if (self.isDataValid() == AccountDataValidity.valid) {
            // Loading...
            self.errorText = "Please Wait"
            session.signUp(email: email, password: password) { (res, error) in
                if error != nil {
                    self.errorText = "Can't register: \(error!.localizedDescription)"
                } else {
                    // res has result
                    print("Sign Up successful :)")
                    self.errorText = "Sign Up successful"
                    self.signUpSuccessFlagForNavigation = true
                }
            }
        } else {
            self.errorText = "Can't register, invalid Input:  \(self.isDataValid().rawValue)"
        }
    }
    
    var body: some View {
        // Add Listener to second pass field. calls isDataValid on every Input
        let repeatPasswordBinding = Binding<String>(get: {
            self.repeatPassword
        }, set: {
            self.repeatPassword = $0
            self.errorText = self.isDataValid().rawValue
        })
        
        
        return ZStack {
            VStack {
                Group {
                    Spacer()
                    Text(FixedStringValues.appName).textStyle(StudyBuddyTitleStyleLevel1a())
                    Text("SignUp").textStyle(StudyBuddyTitleStyleLevel1b())
                    Spacer()
                }
                VStack {
                    Text("Create a new Account").textStyle(StudyBuddyTextStyleLevel1a())
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                    SecureField("Password", text: $password)
                        .textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                    SecureField("Confirm Password", text: repeatPasswordBinding)
                        .textFieldStyle(StudyBuddyTextFieldStyleLevel1())
                }
                Group {
                    Spacer()
                    Text(errorText).foregroundColor(Color.red)
                    Button(action: {
                        self.signUpAction()
                    }) {
                        Text("Register")
                    }.buttonStyle(StudyBuddyButtonStyleLevel1())
                    
                    // Phantom navigation link:
                    NavigationLink("", destination: GeneralTabView(), isActive: $signUpSuccessFlagForNavigation)
                }
                HStack {
                    Text("Already have an account?").textStyle(StudyBuddyTextStyleLevel1b())
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Sign In").textStyle(StudyBuddyTextStyleLevel1c())
                    }
                }
                Group {
                    Spacer()
                    Spacer()
                }
            }.padding(.horizontal)
                .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
                //.offset(x: 0, y: -keyboard.currentHeight)
                .edgesIgnoringSafeArea(.bottom)
                .animation(.easeOut(duration: 0.16))
                .alert(isPresented: $errorDialogVisible) {
                    self.tempAlert.unsafelyUnwrapped
            }
        }
        .navigationBarTitle("Sign Up")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
