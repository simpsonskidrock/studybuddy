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

    



