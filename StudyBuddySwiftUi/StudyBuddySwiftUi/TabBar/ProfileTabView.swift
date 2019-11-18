//
//  ProfileTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileTabView: View {
    @State var loggedOut = false
    var body: some View {
        VStack() {
            HStack() {
                Button(action: {
                    self.loggedOut.toggle()
                }) {
                    Image(systemName: "arrow.uturn.left")
                }.sheet(isPresented: $loggedOut) {
                    LoginView()
                }
                Spacer()
            }.padding(.leading, 10)
            NavigationView {
                List {
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                }
                .navigationBarTitle("Profil")
            }
            Spacer()
        }
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
