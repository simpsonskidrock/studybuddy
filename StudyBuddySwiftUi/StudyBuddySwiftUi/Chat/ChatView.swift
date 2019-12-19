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
    let db = Firestore.firestore()

    @State private var composedMessage: String = ""

   @State private var message : [Message] = []
    
    

    
    func sendMsg(){
        if !composedMessage.isEmpty,
            let messageSender = Auth.auth().currentUser?.email{
            db.collection(FStore.collectionName).addDocument(data:[ FStore.senderField: messageSender, FStore.bodyField: composedMessage])
            { (error) in
                if let e = error{
                    print("there was an issue saving data to Firestore,\(e)")
                }else {
                    print("Successfully saved Data.")
                }
                
                
            }
        }
    }
    
   func loadMessages() {
      message = []
        db.collection(FStore.collectionName).getDocuments { (querySnapshot, error) in
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
    var body: some View {
        
        VStack {
        List {
            ForEach(message, id: \.self) { msg in
                ChatRow(chatMessage: msg)
            }
            
            }

            HStack {
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                    .textFieldStyle(StudyTextFieldStyle())
                Button(action: sendMsg) {
                    Text("Send")
                        .foregroundColor(.black)
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .background(Color.lmuGreen)
        }.onAppear(perform: loadMessages)
        .navigationBarTitle(Text(""))
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

struct ChatRow : View {
    var chatMessage: Message
    
    var body: some View {
        
     Group {
            if !chatMessage.isMe {
                HStack {
                    Group {
                        Text(chatMessage.body)
                            .bold()
                            .padding(10)
                            .cornerRadius(10)
                    }
                    
                }
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.body)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .cornerRadius(10)
                    }
                }
            }
        }

            }
        }

    



