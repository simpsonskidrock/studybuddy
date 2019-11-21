//
//  ContactsTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct ContactsTabView: View {
    @State var showChat = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Chats")
            Spacer()
            List {
                HStack {
                    Text("Person1")
                    Spacer()
                    Button(action: {
                        self.showChat.toggle()
                    }) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 20))
                    }
                    .sheet(isPresented: $showChat) {
                        ChatView()
                    }
                    .foregroundColor(.lmuLightGrey)
                }
                HStack {
                    Text("Person2")
                    Spacer()
                    Button(action: {
                        self.showChat.toggle()
                    }) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 20))
                    }
                    .sheet(isPresented: $showChat) {
                        ChatView()
                    }
                    .foregroundColor(.lmuLightGrey)
                }
            }
            Spacer()
        }.navigationBarTitle("Chats")
    }
}

struct ContactsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsTabView()
    }
}
