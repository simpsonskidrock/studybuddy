//
//  SessionStore.swift
//  StudyBuddySwiftUi
//
//  Created by Manuel Suess on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var sessionUser: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.sessionUser = User(
                    uid: user.uid,
                    email: nil
                )
            } else {
                // if we don't have a user, set our session to nil
                self.sessionUser = nil
            }
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // Authentification //
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut () {
        do {
            try Auth.auth().signOut()
            self.sessionUser = nil
            print("successfully logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // Profile Changes
    
    func addProfile(result: AuthDataResult?) {
        if let authData = result {
            print(authData.user.email!)
            let dict: Dictionary<String, Any> = [
                "uid": authData.user.uid,
                "email": authData.user.email!,
                "displayName": "",
                "fieldOfStudy": "",
                "description": "",
                "hashtags": ""
            ]
            Database.database().reference().child("Users")
                .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        print ("Done")
                    }
                } )
        }
    }
    
    func updateProfile (displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?) {
        self.sessionUser?.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
        // send update to database
     /*   let dict: Dictionary<String, Any> = [
            "uid": sessionUser?.uid,
            "email": sessionUser?.email,
            "displayName": sessionUser?.displayName,
            "fieldOfStudy": sessionUser?.fieldOfStudy,
            "description": sessionUser?.description,
            "hashtags": sessionUser?.hashtags
        ]
        Database.database().reference().child("Users")
            .child(sessionUser?.uid).updateChildValues(dict, withCompletionBlock: {
                (error, ref)in
                if error == nil {
                    print ("Done")
                }
            } )*/
    }
    
    // uploading Images
    
    func uploadImage (imageName: String) {
        let data = Data()
    /*    let riversRef = storageRef.child("images/" + imageName + ".jpg")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
          if let error = error {
            return
          }
          reference.downloadURL(completion: { (url, error) in
            if let error = error { return }
          })
        } */
    }
}
