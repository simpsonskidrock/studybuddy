//
//  ChatView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Foundation


struct ChatMessage : Hashable {
    var message: String
    var avatar: String
    var color: Color
    // isMe will be true if We sent the message
    var isMe: Bool = false
}

struct ChatView : View {
    @EnvironmentObject var chatController: ChatController
    
    @State private var composedMessage: String = ""
    
    private func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "B", color: .lmuLightGrey, isMe: true))
        composedMessage = ""
    }
    
    var body: some View {
        VStack {
            Text("Chat").bold()
            List {
                ForEach(chatController.messages, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }
            HStack {
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                    .textFieldStyle(StudyTextFieldStyle())
                Button(action: self.sendMessage) {
                    Text("Send")
                        .foregroundColor(.black)
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .background(Color.lmuGreen)
        }.navigationBarTitle(Text("Chats"))
    }
}

struct ChatRow : View {
    var chatMessage: ChatMessage
    var body: some View {
        Group {
            if !chatMessage.isMe {
                HStack {
                    Group {
                        Text(chatMessage.avatar)
                        Text(chatMessage.message)
                            .bold()
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                    }
                }
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        Text(chatMessage.avatar)
                    }
                }
            }
        }
        
    }
}
