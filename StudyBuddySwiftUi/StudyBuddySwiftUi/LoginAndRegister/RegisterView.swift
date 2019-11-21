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
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var registered = false
    @State var loading = false
    @State var error = false
    @State var email: String = ""
    @State var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var showingMessageAlert = false
    
    @EnvironmentObject var session: SessionStore
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Wrong Email or Password",         preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        }))
    }
    
    func signUP (){
        loading = true
        error = false
        session.signUp(email: email, password: password) {(result, error) in self.loading = false
            if error != nil {
                print("Error")
                self.error = true
            }
            else {
                self.email = ""
                self.password = ""
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
                
                // todo: for alert if login data is incorrect
                /*    Button(action: {
                 if (self.password.count == 0 || self.email.count == 0 || self.repeatPassword.count == 0 ){
                 self.showingMessageAlert = true
                 } else {
                 self.registered.toggle()
                 }
                 }) {
                 Text("Register")
                 .font(.system(size: 20))
                 .fontWeight(.heavy)
                 }.buttonStyle(StudyButtonStyle())
                 .sheet(isPresented: $registered) {
                 GeneralTabView()
                 }
                 */
                NavigationLink(destination: GeneralTabView()) {
                    Text("Register")
                }.buttonStyle(StudyButtonStyle()) .simultaneousGesture(TapGesture().onEnded{self.signUP()})
                HStack {
                    
                    Text("Already have an account?").foregroundColor(Color.lmuLightGrey)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Sign In") .foregroundColor(.white)
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
                Alert(title: Text("Field is required"), message: Text("You have left a field empty!"), dismissButton: .default(Text("OK")))
            } }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

