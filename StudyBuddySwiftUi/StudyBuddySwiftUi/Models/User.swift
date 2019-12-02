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
    var likedUsers: [String] = []
    var contacts: [String] = []
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
    mutating func updateCompleteProfile(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?, profileImageUrl: String?, likedUsers: [String]?, contacts: [String]?) {
        self.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
        self.updatePicture(profileImageUrl: profileImageUrl)
        self.updateLikeAndMatch(likedUsers: likedUsers, contacts: contacts)
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
    
    mutating func updateLikeAndMatch(likedUsers: [String]?, contacts: [String]?) {
        self.likedUsers = likedUsers!
        self.contacts = contacts!
    }
}
