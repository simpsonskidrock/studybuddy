//
//  ContentView.swift
//  StudyBuddySwiftUi
//
//  Created by Manuel Suess on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ContentView : View {

  @EnvironmentObject var session: SessionStore

  func getUser () {      session.listen()  }
  var body: some View {
    Group {
      if (session.session != nil) {
        Text("Hello user!")
      } else {
        SignInView()
      }
    }.onAppear(perform: getUser)  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()            .environmentObject(SessionStore())
    }
}
