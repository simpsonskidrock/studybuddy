//
//  ChatController.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 23.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//
import Combine
import SwiftUI
import Foundation
import Firebase

class ChatController : ObservableObject {
    let db = Firestore.firestore()
    var didChange = PassthroughSubject<Void, Never>()
    @Published var message : [Message] = []
    
    // ---------------- load messages from FS ---------------- //
     func loadMessages() {
        //retrieve meassages and order it by date
        db.collection(FStore.collectionName).order(by: FStore.dateField).addSnapshotListener{ (querySnapshot, error) in
            self.message = []
              if let e = error {
                  print("there was an issue retrieving data from Firestore,\(e)")
              }else {
                  if let snapShotDocumnets = querySnapshot?.documents {
                      for doc in snapShotDocumnets {
                          let data = doc.data()
                          if let messageSender = data[FStore.senderField] as? String,
                              let messageBody = data[FStore.bodyField] as? String {
                              let newMessage = Message(sender: messageSender, body: messageBody)
                              self.message.append(newMessage)

                              
                          }
                      }
                  }
              }
          }
      }
    
//    func sendMessage(_ chatMessage: ChatMessage) {
//        messages.append(chatMessage)
//        didChange.send(())
//    }
}
