//
//  MessageBubble.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct messageTail : Shape {
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 25, height: 25))
        return Path(path.cgPath)
    }
}

struct ChatRow : View {
    @EnvironmentObject var session: SessionStore
    let chatMessage: Message
    var body: some View {
        Group {
            if (chatMessage.sender != self.session.sessionUser!.uid) {
                VStack{
                    HStack {
                        Text(chatMessage.body)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.lmuDarkGrey)
                            .clipShape(messageTail(mymsg: chatMessage.sender == session.sessionUser?.uid ))
                        Spacer()
                    }
                    HStack {
                        Text(chatMessage.time).font(.custom("SFProText-Bold", size: 12))
                        Spacer()
                    }.padding(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Text(chatMessage.body)
                            .padding(10)
                            .background(Color.lmuLightGrey)
                            .clipShape(messageTail(mymsg: chatMessage.sender == session.sessionUser?.uid ))
                    }
                    HStack {
                        Spacer()
                        Text(chatMessage.time).font(.custom("SFProText-Bold", size: 12))
                    }.padding(.init(top: 0, leading: 0, bottom: 0, trailing: 5))
                }
            }
        }
    }
}
