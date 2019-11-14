//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 13.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Content View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

struct AppView: View {
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
        }
    }
}
