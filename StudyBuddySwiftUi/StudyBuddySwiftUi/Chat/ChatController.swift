//
//  ChatController.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 23.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//
import Combine
import SwiftUI
import Firebase

class ChatController : ObservableObject {
    let db = Firestore.firestore()
    @Published var message : [Message] = []
    
    // ---------------- load messages from FS ---------------- //
    func loadMessages(uid: String, otherUid: String) {
        /** retrieve messages from FireStore and order them by date */
        db.collection(FStore.collectionName).order(by: FStore.dateField).addSnapshotListener{ (querySnapshot, error) in
            self.message = []
            if let e = error {
                print("there was an issue retrieving data from Firestore,\(e)")
            }else {
                if let snapShotDocumnets = querySnapshot?.documents {
                    for doc in snapShotDocumnets {
                        let data = doc.data()
                        if let messageSender = data[FStore.senderField] as? String,
                            let messageReceiver = data[FStore.receiverField] as? String,
                            let messageBody = data[FStore.bodyField] as? String,
                            let messageTime = data[FStore.timeField] as? String
                        {
                            // filter messages per user
                            if (messageSender == uid && messageReceiver == otherUid) || (messageSender == otherUid && messageReceiver == uid) {
                                
                                let newMessage = Message(sender: messageSender, receiver: messageReceiver, body: messageBody, time: messageTime)
                                self.message.append(newMessage)
                            }
                        }
                    }
                }
            }
        }
    }
}
