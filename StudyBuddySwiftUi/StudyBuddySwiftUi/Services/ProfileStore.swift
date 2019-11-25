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
    
    func addProfile(result: AuthDataResult?) {
        if let authData = result {
            print(authData.user.email!)
            let dict: Dictionary<String, Any> = [
                "uid": authData.user.uid,
                "email": authData.user.email!,
                "profileImageUrl": "",
                "Status": ""
            ]
            Database.database().reference().child("Users")
                .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                    (error, ref)in
                    if error == nil {
                        print ("Done")
                    }
                } )
        }
    }
    
    func updateProfile (displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?) {
        self.session?.displayName = displayName
        self.session?.fieldOfStudy = fieldOfStudy
        self.session?.description = description
        self.session?.hashtags = hashtags
        // send update to database
    }
}
