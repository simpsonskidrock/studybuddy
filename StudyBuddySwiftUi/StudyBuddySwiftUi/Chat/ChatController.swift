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

class ChatController : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var messages = [
        ChatMessage(message: "Hello world", avatar: "A", color: .lmuDarkGrey),
    ]
    
    func sendMessage(_ chatMessage: ChatMessage) {
        messages.append(chatMessage)
        didChange.send(())
    }
}
