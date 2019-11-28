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
                    email: user.email
                )
                self.getProfile(uid: user.uid)
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
    
    func signUp (
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn (
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
    
    // Profile //
    
    func getProfile (uid: String?) {
        let rootRef = Database.database().reference(withPath: "Users").child(uid.unsafelyUnwrapped)
        rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?["displayName"] as? String ?? ""
            let fieldOfStudy = value?["fieldOfStudy"] as? String ?? ""
            let description = value?["description"] as? String ?? ""
            let hashtags = value?["hashtags"] as? String ?? ""
            let profileImageUrl = value?["profileImageUrl"] as? String ?? ""
            self.sessionUser?.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
            self.sessionUser?.updatePicture(profileImageUrl: profileImageUrl)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addProfile (result: AuthDataResult?, image: UIImage?) {
        guard let imageSelected = image else {
            print("Image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        if let authData = result {
            print(authData.user.email!)
            var dict: Dictionary<String, Any> = [
                "uid": authData.user.uid,
                "email": authData.user.email!
            ]
            let storageRef = Storage.storage().reference(forURL: "gs://studybuddy-82a88.appspot.com/")
            let storageProfileRef = storageRef.child("Profile").child(authData.user.uid)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metaData, completion: {(StorageMetadata, error) in
                if error != nil {
                    print (error?.localizedDescription)
                    return
                }
                storageProfileRef.downloadURL(completion: {(url, error)in
                    if let metaImageUrl = url?.absoluteString {
                        print (metaImageUrl)
                        dict["profileImageUrl"] = metaImageUrl
                        Database.database().reference().child("Users")
                            .child(authData.user.uid)
                            .updateChildValues(dict, withCompletionBlock: {
                                (error, ref) in
                                if error == nil {
                                    self.sessionUser?.updatePicture(profileImageUrl: metaImageUrl)
                                    print ("Done")
                                }
                            } )
                    }
                } )
            } )
        }
    }
    
    func updateProfile (displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?, image: UIImage?) {
        guard let imageSelected = image else {
            print("Image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let tempUid: String = String((self.sessionUser?.uid)!)
        var dict: Dictionary<String, Any> = [
            "displayName": displayName ?? "",
            "fieldOfStudy": fieldOfStudy ?? "",
            "description": description ?? "",
            "hashtags": hashtags ?? ""
        ]
        let storageRef = Storage.storage().reference(forURL: "gs://studybuddy-82a88.appspot.com/")
        let storageProfileRef = storageRef.child("Profile").child(tempUid)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData, completion: {(StorageMetadata, error) in
            if error != nil {
                print (error?.localizedDescription)
                return
            }
            storageProfileRef.downloadURL(completion: {(url, error)in
                if let metaImageUrl = url?.absoluteString {
                    print (metaImageUrl)
                    dict["profileImageUrl"] = metaImageUrl
                    Database.database().reference().child("Users")
                        .child(tempUid)
                        .updateChildValues(dict, withCompletionBlock: {
                            (error, ref) in
                            if error == nil {
                                self.sessionUser?.updateDetails(displayName: displayName!, fieldOfStudy: fieldOfStudy!, description: description!, hashtags: hashtags!)
                                self.sessionUser?.updatePicture(profileImageUrl: metaImageUrl)
                                print ("Done")
                            }
                        } )
                }
            } )
        } )
    }
}
