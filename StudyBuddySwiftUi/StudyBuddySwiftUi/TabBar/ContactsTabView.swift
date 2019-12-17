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
    @EnvironmentObject var session: CommunicationStore
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    private func initialize() {
        session.getOtherUsers()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)
                    if showCancelButton  {
                        Button("Cancel") {
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }.padding(.horizontal)
                    .navigationBarHidden(showCancelButton)
                List() {
                    ForEach(self.session.sessionUser!.contacts.filter{$0.hasPrefix(searchText) || searchText == ""}, id: \.self) { contact in
                        ContactsLineView(uid: contact, chatAllowed: true)
                    }.onDelete { (indexSet) in
                        let tempContactsBefore: [String] = self.session.sessionUser!.contacts
                        self.session.sessionUser!.contacts.remove(atOffsets: indexSet)
                        let tempContactsAfter: [String] = self.session.sessionUser!.contacts
                        for element in tempContactsBefore {
                            if !tempContactsAfter.contains(element) {
                                self.session.updateContacts(otherUserUid: element)
                            }
                        }
                    }
                    ForEach(self.session.sessionUser!.likedUsers.filter{$0.hasPrefix(searchText) || searchText == ""}, id: \.self) { contact in
                        ContactsLineView(uid: contact, chatAllowed: false)
                    }.onDelete { (indexSet) in
                        self.session.sessionUser!.likedUsers.remove(atOffsets: indexSet)
                        self.session.updateLikedUser()
                    }
                }.navigationBarTitle(Text("Chats"))
                    .resignKeyboardOnDragGesture()
            }
        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: initialize)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
