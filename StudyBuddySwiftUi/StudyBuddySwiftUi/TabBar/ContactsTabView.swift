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
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                HStack{
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
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
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
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)
            List() {
             /*
                 Filtered list of names by search (Todo)
             ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
                 searchText in Text(searchText)
                                                */
                HStack {
                    NavigationLink(destination: ChatView()){
                        Text("Person1")
                    }
                    Spacer()
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 20))
                    .foregroundColor(.lmuLightGrey)
                }
                
               HStack {
                   NavigationLink(destination: ChatView()){
                       Text("Person2")
                   }
                   Spacer()
                       Image(systemName: "bubble.left.and.bubble.right")
                           .font(.system(size: 20))
                   .foregroundColor(.lmuLightGrey)
               }
                
                
            } .navigationBarTitle(Text("Chats"))
            .resignKeyboardOnDragGesture()

           
        }

    }
}
}

struct ContactsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsTabView()
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

