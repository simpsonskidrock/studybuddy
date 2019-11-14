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
        Button(action: {
            self.loggedIn.toggle()
        }) {
            Text("Register")
        }.sheet(isPresented: $loggedIn) {
            GeneralTabView()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

