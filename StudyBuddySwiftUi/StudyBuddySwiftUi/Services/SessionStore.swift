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

//TODO rename to Communication
class SessionStore: ObservableObject {

    var didChange = PassthroughSubject<SessionStore, Never>()
    var sessionUser: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    private var handle: AuthStateDidChangeListenerHandle?
    var otherUsers: [User] = []
    var presentMatchAlert: Bool = false
    var searchWithGPS: Bool = false

    func listen(handler: @escaping ((User) -> ())) {

        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.sessionUser = User(
                    uid: user.uid,
                    email: user.email
                )
                self.getProfile(uid: user.uid, handler: { (user) in
                    handler(user)
                })
            } else {
                // if we don't have a user, set our session to nil
                self.sessionUser = nil
            }
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // ---------------- Authentification ---------------- //
    
    func signUp(

        email: String,
        password: String,
        handler: @escaping (AuthDataResult?, Error?) -> ()
    ) {
        //Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        Auth.auth().createUser(withEmail: email, password: password) { (result, returnError) in
            guard let res = result else {
                handler(nil, returnError)
                return
            }
            self.addSessionUserProfile(result: res) { (error) in
                if (error == nil) {
                    handler(nil, error)
                } else {
                    handler(res, nil)
                }
            }
        }
    }

    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.sessionUser = nil
            print("successfully logged out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func resetPassword(email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ _errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                onSuccess()
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    // ---------------- Profile ---------------- //

    func getProfile(uid: String?, handler: @escaping ((User) -> ())) {
        let rootRef = Database.database().reference(withPath: FixedStringValues.urlIdentifierUser).child(uid!)
        rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let uid = value?[FixedStringValues.uid] as? String ?? ""
            let email = value?[FixedStringValues.email] as? String ?? ""
            let displayName = value?[FixedStringValues.displayName] as? String ?? ""
            let fieldOfStudy = value?[FixedStringValues.fieldOfStudy] as? String ?? ""
            let description = value?[FixedStringValues.description] as? String ?? ""
            let hashtags = value?[FixedStringValues.hashtags] as? String ?? ""
            let profileImageUrl = value?[FixedStringValues.profileImageUrl] as? String ?? ""
            let likedUsers = value?[FixedStringValues.likedUsers] as? [String] ?? []
            let contacts = value?[FixedStringValues.contacts] as? [String] ?? []
            var tempUser: User = User(uid: uid, email: email)
            tempUser.updateCompleteProfile(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags, profileImageUrl: profileImageUrl, likedUsers: likedUsers, contacts: contacts)
            handler(tempUser)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func addSessionUserProfile(result: AuthDataResult?,  handler: @escaping (Error?) -> () ) {
        if let authData = result {
            let dict: Dictionary<String, Any> = [
                FixedStringValues.uid: authData.user.uid,
                FixedStringValues.email: authData.user.email!
            ]

            Database.database().reference().child(FixedStringValues.urlIdentifierUser)
                .child(authData.user.uid)
                .updateChildValues(dict, withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        print("Added Profile: Done")
                        handler(nil)
                    } else {
                        print("Failed to add profile")
                        handler(error)
                    }
                })
        }
    }

    func updateProfile(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?, image: UIImage?) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.updateProfileImage(uid: tempUid, image: image)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.displayName: displayName ?? "",
            FixedStringValues.fieldOfStudy: fieldOfStudy ?? "",
            FixedStringValues.description: description ?? "",
            FixedStringValues.hashtags: hashtags ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                self.sessionUser?.updateDetails(displayName: displayName!, fieldOfStudy: fieldOfStudy!, description: description!, hashtags: hashtags!)
                print("Update ProfileDetails: Done")
            }
        })
    }

    // ---------------- Image ---------------- //

    private func updateProfileImage(uid: String, image: UIImage?) {
        guard let imageSelected = image else {
            print("Image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.1) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: FixedStringValues.storageRef)
        let storageProfileRef = storageRef.child(FixedStringValues.urlIdentifierProfile).child(uid)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData, completion: { (StorageMetadata, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            storageProfileRef.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    let dict: Dictionary<String, Any> = [
                        FixedStringValues.profileImageUrl: metaImageUrl
                    ]
                    Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            self.sessionUser?.updatePicture(profileImageUrl: metaImageUrl)
                            print("Update ProfileImage: Done")
                        }
                    })
                }
            })
        })
    }

    func getProfileImage(profileImageUrl: String, handler: @escaping ((UIImage) -> ())) {
        if (profileImageUrl.isEmpty) {
            print("no profile image")
        } else {
            let storageRef = Storage.storage().reference(forURL: profileImageUrl)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let image = UIImage(data: data!) {
                        handler(image)
                    }
                }
            }
        }
    }

    // ---------------- Other User|s ---------------- //

    func getOtherUsers() {
        self.otherUsers = []
        let rootRef = Database.database().reference(withPath: FixedStringValues.urlIdentifierUser)
        rootRef.observe(.value, with: { (snapshot) in
            for uid in (snapshot.value as? NSDictionary)!.allKeys as! [String] {
                if (uid != self.sessionUser?.uid && !(self.sessionUser?.contacts.contains(uid))! && !(self.sessionUser?.likedUsers.contains(uid))!) {
                    self.getProfile(uid: uid, handler: { user in
                        self.otherUsers.append(user)
                    })
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // ---------------- Like and Match ---------------- //

    func addLikedUser(uid: String) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.sessionUser?.likedUsers.append(uid)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.likedUsers: self.sessionUser?.likedUsers ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                print("Added likedUser")
                self.checkIfLikedUserLikedYou(otherUserUid: uid)
                self.getOtherUsers()
            }
        })
    }
    
    func updateLikedUser() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.likedUsers: self.sessionUser?.likedUsers ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                print ("Deleted likedUser")
                self.getOtherUsers()
            }
        } )
    }
    
    func updateContacts(otherUserUid: String) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.contacts: self.sessionUser?.contacts ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                print ("Deleted likedUser")
                self.getOtherUsers()
                self.getProfile(uid: otherUserUid, handler: { user in
                    var updatedOtherUsersContacts: [String] = []
                    for contact in user.contacts {
                        if contact != tempUid {
                            updatedOtherUsersContacts.append(contact)
                        }
                    }
                    let dictOtherUser: Dictionary<String, Any> = [
                        FixedStringValues.contacts: updatedOtherUsersContacts ?? ""
                    ]
                    Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(otherUserUid).updateChildValues(dictOtherUser, withCompletionBlock: {(error, ref) in
                        if error == nil {
                            print ("Deleted your uid in other users contacts list")
                        }
                    } )
                })
            }
        } )
    }

    private func checkIfLikedUserLikedYou(otherUserUid: String) {
        let rootRef = Database.database().reference(withPath: FixedStringValues.urlIdentifierUser).child(otherUserUid)
        rootRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let otherUserLikedUsers = value?[FixedStringValues.likedUsers] as? [String] ?? []
            var otherUserContacts = value?[FixedStringValues.contacts] as? [String] ?? []
            if (otherUserLikedUsers.contains(self.sessionUser!.uid)) {
                self.sessionUser?.contacts.append(otherUserUid)
                otherUserContacts.append(self.sessionUser!.uid)
                let tempLikes1: [String] = self.sessionUser!.likedUsers
                self.sessionUser?.likedUsers = []
                for likedUser in tempLikes1 {
                    if (likedUser != otherUserUid) {
                        self.sessionUser?.likedUsers.append(otherUserUid)
                    }
                }
                let tempLikes2: [String] = otherUserLikedUsers
                var otherUserLikedUsers: [String] = []
                for likedUser in tempLikes2 {
                    if (likedUser != self.sessionUser?.uid) {
                        otherUserLikedUsers.append(likedUser)
                    }
                }
                self.shareMatch(uid: self.sessionUser!.uid, likedUsers: self.sessionUser?.likedUsers ?? [], contacts: self.sessionUser?.contacts ?? [])
                self.shareMatch(uid: otherUserUid, likedUsers: otherUserLikedUsers, contacts: otherUserContacts)
                self.presentMatchAlert = true
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    private func shareMatch(uid: String, likedUsers: [String], contacts: [String]) {
        let dict: Dictionary<String, Any> = [
            FixedStringValues.likedUsers: likedUsers,
            FixedStringValues.contacts: contacts
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                print("Match!")
            }
        })
    }


    // ---------------- only development ---------------- //

    func deleteData(uid: String, deleteLikes: Bool) {
        var dict: Dictionary<String, Any>
        if deleteLikes {
            dict = [
                FixedStringValues.likedUsers: [],
                FixedStringValues.contacts: []
            ]
        } else {
            dict = [
                FixedStringValues.contacts: []
            ]
        }
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                print("Deleted!")
            }
        })
    }
}
