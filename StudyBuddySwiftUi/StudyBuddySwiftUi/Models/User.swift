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
    var displayName: String?
    var fieldOfStudy: String?
    var description: String?
    var hashtags: String?
    var profileImageUrl: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
    mutating func updateDetails(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?) {
        self.displayName = displayName
        self.fieldOfStudy = fieldOfStudy
        self.description = description
        self.hashtags = hashtags
    }
    
    mutating func updatePicture(profileImageUrl: String?) {
        self.profileImageUrl = profileImageUrl
    }
}
