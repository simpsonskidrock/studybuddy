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
    
    @EnvironmentObject var session: CommunicationStore

    let db = Firestore.firestore()
    @ObservedObject var chatController = ChatController()
    @State private var composedMessage: String = ""

     


    func sendMsg(){
        if !composedMessage.isEmpty,
            let messageSender = Auth.auth().currentUser?.email{
            db.collection(FStore.collectionName).addDocument(data:[ FStore.senderField: messageSender, FStore.bodyField: composedMessage, FStore.dateField: Date().timeIntervalSince1970])
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
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                    .textFieldStyle(StudyTextFieldStyle())
                Button(action: sendMsg) {
                    Text("Send")
                        .foregroundColor(.black)
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .background(Color.lmuGreen)
        }.onAppear(perform: chatController.loadMessages)
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
                        Image("MeAvatar")
                    }
                }
            }
        }

            }
        }

    



