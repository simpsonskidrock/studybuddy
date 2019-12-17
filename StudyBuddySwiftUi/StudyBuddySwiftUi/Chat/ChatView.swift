//
//  ChatView1.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct ChatView: View {
   
    @State private var composedMessage: String = ""

    var message : [Message] = [
        Message(sender: "A", body: "Hallo"),
        
        Message(sender: "B", body: "Hi")

        
      ]
    
     var messages = [
        ChatMessage(message: "Hello world", avatar: "A", color: .lmuDarkGrey),
    ]
    
    
    var body: some View {
        VStack {
        List {
            ForEach(messages, id: \.self) { msg in
                Group {
                    Text(msg.avatar)
                    Text(msg.message)

                }
            }
            
            }

            HStack {
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                    .textFieldStyle(StudyTextFieldStyle())
                Button(action: {}) {
                    Text("Send")
                        .foregroundColor(.black)
                }
            }.frame(minHeight: CGFloat(50)).padding()
                .background(Color.lmuGreen)
        }.navigationBarTitle(Text(""))
    }
}

struct ChatView1_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}


struct ChatMessage : Hashable {
       var message: String
       var avatar: String
    var color: Color
    var isMe: Bool = false
   }
   


struct ChatRow : View {
    var chatMessage: ChatMessage
    var myMsg = false
    
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

    



