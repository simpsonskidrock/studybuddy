//
//  Message.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 17.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation


struct Message: Hashable{
    let sender : String
    let body: String
    
    var isMe: Bool = false

}
