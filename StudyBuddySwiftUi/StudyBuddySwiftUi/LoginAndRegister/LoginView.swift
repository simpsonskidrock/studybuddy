//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error_FieldIsEmpty = false
    
    var alertEmptyField: Alert = Alert(title: Text("Field is required"), message: Text("You have left a field empty!"), dismissButton: .default(Text("OK")))
    
    var alertIncorrectLogInData: Alert = Alert(title: Text("Error"), message: Text("Please enter a valid Email and Password"), dismissButton: .default(Text("OK")))
    
    func getUser () {
        session.listen()
    }
    
    func signIn () {
        self.loading = true
        self.error_FieldIsEmpty = false
        session.signIn(email: email, password: password) { (result, error_FieldIsEmpty) in
            self.loading = false
            if error_FieldIsEmpty != nil {
                self.error_FieldIsEmpty = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer()
                Image("fountainicon")
                Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                
                Spacer()
                Text("Enter email and password").foregroundColor(Color.white)
                
                TextField("Email", text: $email)
                    .textFieldStyle(StudyTextFieldStyle())
                    .padding(.horizontal, 50)
                SecureField("Password", text: $password)
                    .textFieldStyle(StudyTextFieldStyle())
                    .padding(.horizontal, 50)
                HStack {
                    Spacer()
                    NavigationLink(destination: GeneralTabView()) {
                        Text("Log In")
                    }.buttonStyle(StudyButtonStyle())                 .simultaneousGesture(TapGesture().onEnded{self.signIn()})
                    Text("or").foregroundColor(Color.white)
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())
                    
                }
                HStack {
                    Text("Forgot your password?").foregroundColor(Color.lmuLightGrey)
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Click here").foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .onAppear(perform: getUser)
            .padding(.horizontal, 20.0).background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .alert(isPresented: $error_FieldIsEmpty) {
                self.alertEmptyField
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
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

