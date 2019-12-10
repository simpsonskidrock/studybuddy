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
                    ForEach(self.session.sessionUser!.contacts, id: \.self) { contact in
                        ContactsLineView(uid: contact, chatAllowed: true)
                    }
                    ForEach(self.session.sessionUser!.likedUsers, id: \.self) { contact in
                        ContactsLineView(uid: contact, chatAllowed: false)
                    }
                }.navigationBarTitle(Text("Chats"))
                    .resignKeyboardOnDragGesture()
            }
        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
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

struct ContactsLineView: View {
    @EnvironmentObject var session: SessionStore
    
    var uid: String
    var chatAllowed: Bool
    
    @State var name: String = ""
    @State var image: UIImage = UIImage(systemName: "person")
    
    func getImage(path: String) {
        if(!path.isEmpty) {
            self.session.getProfileImage(profileImageUrl: path, handler: { (image) in
                DispatchQueue.main.async{
                    self.image = image
                }
            })
        }
    }
    
    func initialize() {
        self.session.getProfile(uid: uid, handler: { user in
            self.name = user.displayName!
            self.getImage(path: user.profileImageUrl!)
        })
        
    }
  
    var body : some View {
        HStack {
            if chatAllowed {
                ImageView(image: image!)
                UserNameView(name: name)
                Spacer()
                NavigationLink(destination: ChatView()){
                    Text("Match")
                }
            } else {
                ImageView(image: image!)

                UserNameView(name: name)
                Spacer()
                Text("Like")
            }
        }.onAppear(perform: initialize)
    }
}

struct ImageView: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
        .scaledToFit()
            .overlay(
            Circle()
                    .clipped()
        )
    }
}

struct UserNameView: View {
    let name: String
    
    var body: some View {
       
            Text("\(name)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
        
       
    }
}
