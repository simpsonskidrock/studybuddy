//
//  WaitForSessionUserView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 05.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct WaitForSessionUserView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    
    var email: String
    var password: String
    
    @State var correctLoginData: Bool = false
    
    private func signIn () {
        session.signIn(email: self.email, password: self.password) { (result, error_FieldIsEmpty) in
            if error_FieldIsEmpty != nil {
                self.mode.wrappedValue.dismiss()
            } else {
                self.correctLoginData.toggle()
            }
        }
    }
    
    var body: some View {
        VStack {
            if self.correctLoginData {
                GeneralTabView()
            } else {
                Color.lmuGreen
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
                VStack {
                    Spacer()
                    Image("fountainicon")
                    Spacer()
                })
            }
        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: signIn)
    }
}
