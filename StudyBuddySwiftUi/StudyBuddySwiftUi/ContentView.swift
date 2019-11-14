//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var loggedIn = false
    @State var isRegistered = false
    var body: some View {
        VStack {
            Image("fountainicon").resizable()
            .aspectRatio(contentMode: ContentMode.fit)
            Text("StudyBuddy")
            Button(action: {
                self.loggedIn.toggle()
            }) {
                Text("Log In")
            }.sheet(isPresented: $loggedIn) {
                GeneralTabView()
            }
            Button(action: {
                self.isRegistered.toggle()
            }) {
                Text("Register")
            }.sheet(isPresented: $isRegistered) {
                RegisterView()
            }
        }.background(Color("LMU Green"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
