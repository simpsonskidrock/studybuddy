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
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("StudyBuddy")
            Spacer()
            Text("Enter username or password")
            TextField("username", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(.horizontal)
            TextField("password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .padding(.horizontal)
            TextField("repeat password", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
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

