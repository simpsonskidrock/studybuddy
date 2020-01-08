//
//  Message.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation


struct Message: Hashable {
    let sender : String
    let receiver : String
    let body: String

}
struct FStore {
    static let collectionName = "messages"
    static let senderField = "sender"
    static let receiverField = "receiver"
    static let bodyField = "body"
    static let dateField = "date"
}
