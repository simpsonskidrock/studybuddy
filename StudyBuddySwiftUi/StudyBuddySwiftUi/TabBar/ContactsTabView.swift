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
    @EnvironmentObject var session: SessionStore
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    private func initialize() {
        self.session.getProfile(uid: self.session.sessionUser!.uid, handler: { user in
            self.session.sessionUser = user
            self.session.downloadAllUserLists()
        })
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
                    ForEach(self.session.matchedUsers.filter{$0.displayName?.hasPrefix(searchText) ?? false || searchText == ""}, id: \.uid) { contact in
                        ContactsLineView(uid: contact.uid, chatAllowed: true)
                    }.onDelete { (indexSet) in
                        indexSet.forEach {i in
                            let uidToRemove:String = self.session.matchedUsers[i].uid
                            self.session.removeMatchedUser(uidToRemove: uidToRemove)
                        }
                        self.session.matchedUsers.remove(atOffsets: indexSet)
                    }
                    ForEach(self.session.likedUsers.filter{$0.displayName?.hasPrefix(searchText) ?? false || searchText == ""}, id: \.uid) { contact in
                        ContactsLineView(uid: contact.uid, chatAllowed: false)
                    }.onDelete { (indexSet) in
                        indexSet.forEach {i in
                            let uidToRemove:String = self.session.likedUsers[i].uid
                            self.session.removeLikedUser(uidToRemove: uidToRemove)
                        }
                        self.session.likedUsers.remove(atOffsets: indexSet)
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
