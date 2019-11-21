//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var registered = false
    @State var loading = false
    @State var error = false
    @State var tempAlert: Alert = nil
    
    @State var email: String = ""
    @State var password: String = ""
    @State private var repeatPassword: String = ""
    
    func signUP (){
        self.loading = true
        self.error = false
        if (self.email == "" || self.password == "" || self.repeatPassword == "") {
            self.error = true
            self.tempAlert = Alert.alertEmptyField
        } else if (self.password.count < 6 || self.repeatPassword.count < 6) {
            self.error = true
            self.tempAlert = Alert.alertTooShortPassword
        } else if (self.password != self.repeatPassword) {
            self.error = true
            self.tempAlert = Alert.alertUnequalPassword
        }
        else {
            session.signUp(email: email, password: password) {(result, error_FieldIsEmpty) in self.loading = false
                if error_FieldIsEmpty != nil {
                    print("Error")
                    self.error = true
                    self.tempAlert = Alert.alertIncorrectData
                }
                else {
                    self.email = ""
                    self.password = ""
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("SignUp").font(.largeTitle).foregroundColor(.lmuLightGrey)
                Spacer()
                Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 100, height: 100.0)
                    .colorInvert()
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 150, height: 150))
                    .padding(.vertical, 35)
                VStack {
                    Text("Create a new Account").foregroundColor(Color.white)
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    SecureField("Password", text: $password)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                    SecureField("Confirm Password", text: $repeatPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                        .padding(.horizontal, 50)
                }
                NavigationLink(destination: GeneralTabView()) {
                    Text("Register")
                }.buttonStyle(StudyButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded{self.signUP()})
                HStack {
                    Text("Already have an account?").foregroundColor(Color.lmuLightGrey)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Sign In").foregroundColor(.white)
                    }
                }
                Spacer()
                Spacer()
            }
            .padding(.horizontal) .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .alert(isPresented: $error) {
                self.tempAlert.unsafelyUnwrapped
            }
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

