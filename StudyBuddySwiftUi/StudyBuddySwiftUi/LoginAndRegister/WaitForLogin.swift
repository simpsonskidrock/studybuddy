//
//  WaitForLogin.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 15.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase

struct WaitForLogin: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            if Auth.auth().currentUser != nil {
                GeneralTabView()
            } else {
                LoginView()
            }
        }
    }
}
