//
//  ResetPasswordView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 01.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var session: SessionStore

    @Environment(\.presentationMode) var mode
    
    @State private var email: String = ""
    @State var loading = false
       @State var error = false
       @State var tempAlert: Alert = nil

    
    func ResetPassword() {
        self.error = false
        if (self.email == "" ) {
            self.error = true
            self.tempAlert = Alert.alertEmptyField
        }
                else {
            self.session.resetPassword(email: email, onSuccess: {
                 self.error = true
           // self.tempAlert = Alert.alertsuccessResetPassword
              
                
            }){
                (errorMessage) in
                print(self.error)
            }
                   
        }
    }
    

    var body: some View {
       ZStack {
                   VStack {
                       Text("Reset Password").font(.largeTitle).foregroundColor(.lmuLightGrey)
                       Spacer()
                       Text(Strings().appName).font(.largeTitle).foregroundColor(Color.white)
                       Spacer()
                       VStack {
                           Text("Enter Your Email Address").foregroundColor(Color.white)
                           TextField("E-mail", text: $email)
                               .textFieldStyle(StudyTextFieldStyle())
                          
                       }
                    NavigationLink(destination: LoginView()) {
                           Text("Reset Password").font(.system(size: 20))
                               .fontWeight(.heavy)
                       }.buttonStyle(StudyButtonStyle()).simultaneousGesture(TapGesture().onEnded{self.ResetPassword()})

                       HStack {
                           Text("Don't want to Reset your password?").foregroundColor(Color.lmuLightGrey)
                           Button(action: {
                               self.mode.wrappedValue.dismiss()
                           }) {
                               Text("Cancel") .foregroundColor(.white)
                           }
                       }
                       Spacer()
                   }.padding(.horizontal)
                    .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
                   .edgesIgnoringSafeArea(.bottom)
                   .animation(.easeOut(duration: 0.16))
        .alert(isPresented: $error) {
            self.tempAlert.unsafelyUnwrapped
        }

    }
    }
}


struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
