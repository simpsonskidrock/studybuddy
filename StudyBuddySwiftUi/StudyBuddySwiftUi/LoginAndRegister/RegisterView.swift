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
    @ObservedObject private var keyboard = KeyboardResponder()

    // for the registerButton TODO rename
    @State private var signUpSuccessFlagForNavigation: Bool = false
    @State private var errorText: String = ""


    @State private var errorDialogVisible: Bool = false
    @State private var tempAlert: Alert = nil

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""




    func isDataValid() -> RegisterDataValidity {
        if (self.email == "" || self.password == "" || self.repeatPassword == "") {
            return RegisterDataValidity.invalidEmail
        } else if (!email.matches("[^@]+@[^\\.]+\\..+")) {
            return RegisterDataValidity.invalidEmail
        } else if (self.password.count < 6) {
            return RegisterDataValidity.shortPassword
        } else if (self.password != self.repeatPassword) {
            return RegisterDataValidity.unequalPasswords
        }
        return RegisterDataValidity.valid
    }

    /**
     checks Data registers
     */
    func signUp() -> SignUpReturnCode {
        var returnCode: SignUpReturnCode = SignUpReturnCode.UNKNOWN
        if (self.isDataValid() == RegisterDataValidity.valid) {
            if (SignUpReturnCode.SUCCESS == session.signUp(email: email, password: password) { (error) in
                if error != nil {
                    returnCode = SignUpReturnCode.ERROR(message: error!.localizedDescription)
                } else {
                    // No error / error = nil
                    returnCode = SignUpReturnCode.SUCCESS
                }
            }) {
                //SUCCESS
                

            }


        } else {
            return SignUpReturnCode.INVALID_DATA
        }
        return returnCode
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
                    Text(FixedStringValues.appName).font(.largeTitle)
                        .foregroundColor(Color.white)
                    Spacer()
                    Text("SignUp").font(.largeTitle)
                        .foregroundColor(.lmuLightGrey)
                    Spacer()


                }
                VStack {
                    Text("Create a new Account").foregroundColor(Color.white).font(.title)
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("Confirm Password", text: repeatPasswordBinding)
                        .textFieldStyle(StudyTextFieldStyle())
                }
                Group {
                    Spacer()
                    Text(errorText).foregroundColor(Color.red)
                    Button(action: {
                        let SignUpReturnCode = self.signUp()
                        var longMessage = ""
                        switch (SignUpReturnCode) {

                        case .SUCCESS:
                            longMessage = "Register successful"
                            self.signUpSuccessFlagForNavigation = true
                        case .ERROR(let message):
                            longMessage = "Error during SignUp: \(message)"
                            self.errorText = longMessage
                        case .UNKNOWN:
                            longMessage = "Unknown Return code from SignUp()"
                        case .INVALID_DATA:
                            longMessage = "Invalid Data, please reenter email and passwords."
                        }
                        print(longMessage)

                    }) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())

                    // Phantom navigation link:
                    NavigationLink("", destination: GeneralTabView(), isActive: $signUpSuccessFlagForNavigation)

                }
                //                NavigationLink(destination: {
                //                    VStack {
                //                        if loginSuccess {
                //                            GeneralTabView()
                //                        } else {
                //                            // Not going to GeneralTabView
                //                            RegisterView()
                //                        }
                //                    }
                //                }()) {
                //                    Text("Register")
                //                }.buttonStyle(StudyButtonStyle())
                //                    .simultaneousGesture(TapGesture().onEnded{self.signUp()})
                //

                HStack {
                    Text("Already have an account?").foregroundColor(Color.lmuLightGrey)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Sign In").foregroundColor(.white)
                    }
                }
                Group {
                    Spacer()
                    Spacer()
                }
            }.padding(.horizontal)
                .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
                .offset(x: 0, y: -keyboard.currentHeight)
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
