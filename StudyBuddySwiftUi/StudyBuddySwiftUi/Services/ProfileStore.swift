//
//  ProfileStore.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 22.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class ProfileStore : ObservableObject {
    var didChange = PassthroughSubject<ProfileStore, Never>()
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    init(session: User) {
        self.session = session
    }

    func listen () {
        
    }
    
    func updateProfile (displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?) {
        self.session?.displayName = displayName
        self.session?.fieldOfStudy = fieldOfStudy
        self.session?.description = description
        self.session?.hashtags = hashtags
        // TODO: send to firebase database
    }
}

