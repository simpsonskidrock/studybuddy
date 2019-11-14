//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State var loggedIn = false
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("StudyBuddy")
            Spacer()
            Text("Enter username or password")
            TextField("username", text: $userName)
                .padding(.horizontal)
            
            TextField("password", text: $password)
                .padding(.horizontal)
            TextField("repeat password", text: $repeatedPassword)
                .padding(.horizontal)
            HStack(spacing: 8) {
                Spacer()
                Button(action: {
                    self.loggedIn.toggle()
                }) {
                    Text("Register")
                }.sheet(isPresented: $loggedIn) {
                    GeneralTabView()
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 20.0)
        .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

