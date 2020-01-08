//
//  ChatView1.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase

struct ChatView: View {
    
    @EnvironmentObject var session: SessionStore
    
    let db = Firestore.firestore()
    @ObservedObject var chatController = ChatController()
    @State private var composedMessage: String = ""
    
    let uid: String?
    
    func initialize() {
        self.chatController.loadMessages(uid: self.session.sessionUser!.uid, otherUid: uid!)
    }
    
    //send message and save it to Firestore
    func sendMsg(){
        if !composedMessage.isEmpty,
            let messageSender = self.session.sessionUser?.uid,
            let messageReceiver = self.uid
        {
            db.collection(FStore.collectionName).addDocument(data:[ FStore.senderField: messageSender, FStore.receiverField: messageReceiver, FStore.bodyField: composedMessage, FStore.dateField: Date().timeIntervalSince1970])
            { (error) in
                if let e = error{
                    print("there was an issue saving data to Firestore,\(e)")
                }else {
                    print("Successfully saved Data.")
                    
                    DispatchQueue.main.async {
                        self.composedMessage = ""
                    }
                }
                
                
            }
        }
    }
    
    var body: some View {
        
        VStack {
            ChatHeaderView(uid: self.uid!)
            List {
                ForEach(chatController.message, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
                
            }
            
            HStack {
                TextField(" Message...", text: $composedMessage).frame(minHeight: CGFloat(50))
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Button(action: sendMsg) {
                    Text("Send")
                        .foregroundColor(.black)
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .background(Color.lmuGreen)
        }.onAppear(perform: initialize)
            .navigationBarTitle(Text(""))
        
        
    }
}

struct ChatRow : View {
    
    @EnvironmentObject var session: SessionStore
    
    let chatMessage: Message
    
    var body: some View {
        
        Group {
            if (chatMessage.sender != self.session.sessionUser!.uid) {
                HStack {
                    Group {
                        Text(chatMessage.body)
                            .padding(10)
                            .cornerRadius(10)
                    }
                    
                }
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.body)
                            .padding(10)
                            .cornerRadius(10)
                        Image("MeAvatar")
                    }
                }
            }
        }
        
    }
}





