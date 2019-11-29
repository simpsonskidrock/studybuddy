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
    
    func initialize() {
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
    }
}

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchTabView()
                .environment(\.colorScheme, .light)
            SearchTabView()
                .environment(\.colorScheme, .dark)
        }
    }
}

