//
//  User.swift
//  StudyBuddySwiftUi
//
//  Created by Manuel Suess on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//
import SwiftUI

struct User {
    var uid: String
    var email: String?
    @State var displayName: String?
    @State var fieldOfStudy: String?
    @State var description: String?
    @State var hashtags: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
    func updateDetails(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?) {
        self.displayName = displayName
        self.fieldOfStudy = fieldOfStudy
        self.description = description
        self.hashtags = hashtags
    }
}
