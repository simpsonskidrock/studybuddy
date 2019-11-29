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
    var otherUsers: [User] = []
    
    
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
    
    // ---------------- Authentification ---------------- //
    
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
    
    // ---------------- Profile ---------------- //
    
    func getProfile (uid: String?) {
        let rootRef = Database.database().reference(withPath: Strings().urlIdentifierUser).child(uid.unsafelyUnwrapped)
        rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?[Strings().displayName] as? String ?? ""
            let fieldOfStudy = value?[Strings().fieldOfStudy] as? String ?? ""
            let description = value?[Strings().description] as? String ?? ""
            let hashtags = value?[Strings().hashtags] as? String ?? ""
            let profileImageUrl = value?[Strings().profileImageUrl] as? String ?? ""
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
            let dict: Dictionary<String, Any> = [
                Strings().uid: authData.user.uid,
                Strings().email: authData.user.email!
            ]
            self.updateProfileImage(uid: authData.user.uid, image: image)
            Database.database().reference().child(Strings().urlIdentifierUser)
                .child(authData.user.uid)
                .updateChildValues(dict, withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        print ("Added Profile: Done")
                    }
                } )
        }
    }
    
    func updateProfile (displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?, image: UIImage?) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.updateProfileImage(uid: tempUid, image: image)
        let dict: Dictionary<String, Any> = [
            Strings().displayName: displayName ?? "",
            Strings().fieldOfStudy: fieldOfStudy ?? "",
            Strings().description: description ?? "",
            Strings().hashtags: hashtags ?? ""
        ]
        Database.database().reference().child(Strings().urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                self.sessionUser?.updateDetails(displayName: displayName!, fieldOfStudy: fieldOfStudy!, description: description!, hashtags: hashtags!)
                print ("Update ProfileDetails: Done")
            }
        } )
    }
    
    // ---------------- Image ---------------- //
    
    func updateProfileImage(uid: String, image: UIImage?) {
        guard let imageSelected = image else {
            print("Image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: Strings().storageRef)
        let storageProfileRef = storageRef.child(Strings().urlIdentifierProfile).child(uid)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData, completion: {(StorageMetadata, error) in
            if error != nil {
                print (error?.localizedDescription ?? "")
                return
            }
            storageProfileRef.downloadURL(completion: {(url, error)in
                if let metaImageUrl = url?.absoluteString {
                    let dict: Dictionary<String, Any> = [
                        Strings().profileImageUrl: metaImageUrl
                    ]
                    Database.database().reference().child(Strings().urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
                        if error == nil {
                            self.sessionUser?.updatePicture(profileImageUrl: metaImageUrl)
                            print ("Update ProfileImage: Done")
                        }
                    } )
                }
            } )
        })
    }
    
    func getProfileImage(profileImageUrl: String) -> UIImage? { // Still not working
        let image: UIImage? = UIImage()
    /*    let storageRef = Storage.storage().reference(forURL: profileImageUrl)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("loading profile image: error")
          } else {
            image = UIImage(data: data!)
            print("loaded profile image:", image)
          }
        }
        print("given profile image:", image) */
        return image
    }
    
    // ---------------- Other User|s ---------------- //
    
    func getOtherUsers () {
        self.otherUsers = []
        let rootRef = Database.database().reference(withPath: Strings().urlIdentifierUser)
        rootRef.observe(.value, with: { (snapshot) in
            for uid in (snapshot.value as? NSDictionary)!.allKeys as! [String] {
                if (uid != self.sessionUser?.uid) {
                    self.getOtherUser(uid: uid)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getOtherUser (uid: String?) {
        var user: User = User(uid: uid!, email: "")
        let rootRef = Database.database().reference(withPath: Strings().urlIdentifierUser).child(uid.unsafelyUnwrapped)
        rootRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?[Strings().displayName] as? String ?? ""
            let fieldOfStudy = value?[Strings().fieldOfStudy] as? String ?? ""
            let description = value?[Strings().description] as? String ?? ""
            let hashtags = value?[Strings().hashtags] as? String ?? ""
            let profileImageUrl = value?[Strings().profileImageUrl] as? String ?? ""
            user.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
            user.updatePicture(profileImageUrl: profileImageUrl)
            self.otherUsers.append(user)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
