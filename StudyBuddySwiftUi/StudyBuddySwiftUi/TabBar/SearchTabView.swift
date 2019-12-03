//
//  SearchTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchTabView: View {
    @EnvironmentObject var session: SessionStore
    
    private func initialize() {
        session.getOtherUsers()
    }
    
    var body: some View {
        VStack {
            SwipeView(users: session.otherUsers)
        }.navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .padding(.horizontal)
            .padding(.bottom)
        .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
        .onAppear(perform: initialize)
        .alert(isPresented: $session.presentMatchAlert) {
            Alert.alertMatch
        }
    }
}
