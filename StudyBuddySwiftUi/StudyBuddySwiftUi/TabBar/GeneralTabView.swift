//
//  GeneralTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct GeneralTabView: View {
    var body: some View {
        TabView {
            ProfileTabView()
                .tabItem {
                    Image(systemName: "person")
            }
            SearchTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
            }
            ContactsTabView()
                .tabItem {
                    Image(systemName: "person.3")
            }
        }.navigationBarHidden(true).navigationBarBackButtonHidden(true)
        .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
    }
}

struct GeneralTabView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralTabView()
    }
}

