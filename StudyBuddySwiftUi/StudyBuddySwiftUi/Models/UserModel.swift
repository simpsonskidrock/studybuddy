//
//  UserModel.swift
//  StudyBuddySwiftUi
//
//  Created by Manuel Suess on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//
import SwiftUI

struct UserModel : Hashable {
    var uid: String
    var email: String?
    var displayName: String?
    var fieldOfStudy: String?
    var description: String?
    var hashtags: [String] = []
    var profileImageUrl: String?
    var likedUsers: [String] = []
    var contacts: [String] = []
    var gpsUsage: Bool?
    var location: LocationModel?
    var distance: Double?
    
    var hashValue: Int {
        return uid.hashValue ^ email.hashValue ^ displayName.hashValue
    }

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
    
    mutating func updateCompleteProfile(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: [String], profileImageUrl: String?, likedUsers: [String]?, contacts: [String]?, gpsUsage: Bool, location: LocationModel?) {
        self.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
        self.updatePicture(profileImageUrl: profileImageUrl)
        self.updateLikeAndMatch(likedUsers: likedUsers, contacts: contacts)
        self.updateGpsUsage(gpsUsage: gpsUsage)
        if location != nil {
            self.updateLocation(location: location!)
        }
    }
    
    mutating func updateDetails(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: [String]) {
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
    
    mutating func updateGpsUsage(gpsUsage: Bool) {
        self.gpsUsage = gpsUsage
    }
    
    mutating func updateLocation(location: LocationModel) {
        self.location = location
    }
    
    mutating func updateDistance(distance: Double?){
        self.distance = distance
    }
    
    func toString() -> String {
        var line = ""
        line += displayName?.padding(toLength: 25, withPad: " ", startingAt: 0) ?? "Name is null"
        line += fieldOfStudy?.padding(toLength: 30, withPad: " ", startingAt: 0) ?? "Study is null"
        line += description?.padding(toLength: 40, withPad: " ", startingAt: 0) ?? "Description is null"
        return line
    }
    
    func getHashtagsAsString() -> String {
        var temp: String = ""
        for tag in self.hashtags {
            temp += "#\(tag) "
        }
        return temp
    }
}
