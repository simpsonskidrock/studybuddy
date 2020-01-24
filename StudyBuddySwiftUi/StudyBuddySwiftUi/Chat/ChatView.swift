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
    @Environment(\.presentationMode) var mode
    
    @ObservedObject var chatController = ChatController()
    @State private var composedMessage: String = ""
    
    let db = Firestore.firestore()
    let uid: String?
    
    /** this method is to remove the line seprators from list */
    func removeLines() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .none
    }
    
    func loadChatMessages() {
        self.chatController.loadMessages(uid: self.session.sessionUser!.uid, otherUid: uid!)
        removeLines()
    }
    
    /** send message and save it to Firestore */
    func sendMsg(){
        if !composedMessage.isEmpty,
            let messageSender = self.session.sessionUser?.uid,
            let messageReceiver = self.uid {
            let timeNow = Date()
            let formater = DateFormatter()
            formater.dateFormat = "EE' 'HH:mm"
            db.collection(FStore.collectionName).addDocument(data:[ FStore.senderField: messageSender, FStore.receiverField: messageReceiver, FStore.bodyField: composedMessage, FStore.dateField: Date().timeIntervalSince1970, FStore.timeField: formater.string(from: timeNow)])
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
            List {
                ForEach(chatController.message, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }
            HStack {
                TextField(" Message...", text: $composedMessage)
                    .font(.system(size: 15))
                    .frame(minHeight: CGFloat(40))
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Button(action: sendMsg) {
                    Image(systemName:"paperplane")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .background(Color.lmuGreen)
        }.onAppear(perform: loadChatMessages)
            .navigationBarItems(leading:
                HStack{
                   
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    ChatHeaderView(uid: self.uid!)
                })
    }
}
