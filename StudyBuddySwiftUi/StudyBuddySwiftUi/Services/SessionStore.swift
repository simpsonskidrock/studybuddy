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
    private var handle: AuthStateDidChangeListenerHandle?
    var otherUsers: [User] = []
    var presentMatchAlert: Bool = false
    @Published var data: Data?

    func listen() {
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
                    self.sessionUser?.updateCompleteProfile(displayName: user.displayName, fieldOfStudy: user.fieldOfStudy, description: user.description, hashtags: user.hashtags, profileImageUrl: user.profileImageUrl, likedUsers: user.likedUsers, contacts: user.contacts)
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
        handler: @escaping (Error?)->()
    ) {
        //Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let res = result else {
                handler(error)
                return
            }
            do {
                try self.addProfile(result: res)
                handler(nil)
            } catch {
                print("ADD PROFILE FAILED")
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
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping( _ _errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                onSuccess()
            } else {
                (error?.localizedDescription)
            }
        }
    }
    
    // ---------------- Profile ---------------- //
    
    func getProfile(uid: String?, handler: @escaping((User)->())) {
        let rootRef = Database.database().reference(withPath: Strings.urlIdentifierUser).child(uid!)
        rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let uid = value?[Strings.uid] as? String ?? ""
            let email = value?[Strings.email] as? String ?? ""
            let displayName = value?[Strings.displayName] as? String ?? ""
            let fieldOfStudy = value?[Strings.fieldOfStudy] as? String ?? ""
            let description = value?[Strings.description] as? String ?? ""
            let hashtags = value?[Strings.hashtags] as? String ?? ""
            let profileImageUrl = value?[Strings.profileImageUrl] as? String ?? ""
            let likedUsers = value?[Strings.likedUsers] as? [String] ?? []
            let contacts = value?[Strings.contacts] as? [String] ?? []
            var tempUser: User = User(uid: uid, email: email)
            tempUser.updateCompleteProfile(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags, profileImageUrl: profileImageUrl, likedUsers: likedUsers, contacts: contacts)
            handler(tempUser)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addProfile(result: AuthDataResult?) throws {
        if let authData = result {
            let dict: Dictionary<String, Any> = [
                Strings.uid: authData.user.uid,
                Strings.email: authData.user.email!
            ]
            //self.updateProfileImage(uid: authData.user.uid, image: image)
            
            var success = false
            Database.database().reference().child(Strings.urlIdentifierUser)
                .child(authData.user.uid)
                .updateChildValues(dict, withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        success = true
                    }
                } )
            if (success) {
                print ("Added Profile: Done")
            } else {
              //  throw RegisterError.unknown(message: "Hmm")
            }
        }
    }
    
    func updateProfile(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?, image: UIImage?) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.updateProfileImage(uid: tempUid, image: image)
        let dict: Dictionary<String, Any> = [
            Strings.displayName: displayName ?? "",
            Strings.fieldOfStudy: fieldOfStudy ?? "",
            Strings.description: description ?? "",
            Strings.hashtags: hashtags ?? ""
        ]
        Database.database().reference().child(Strings.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                self.sessionUser?.updateDetails(displayName: displayName!, fieldOfStudy: fieldOfStudy!, description: description!, hashtags: hashtags!)
                print ("Update ProfileDetails: Done")
            }
        } )
    }
    
    // ---------------- Image ---------------- //
    
    private func updateProfileImage(uid: String, image: UIImage?) {
        guard let imageSelected = image else {
            print("Image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: Strings.storageRef)
        let storageProfileRef = storageRef.child(Strings.urlIdentifierProfile).child(uid)
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
                        Strings.profileImageUrl: metaImageUrl
                    ]
                    Database.database().reference().child(Strings.urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
                        if error == nil {
                            self.sessionUser?.updatePicture(profileImageUrl: metaImageUrl)
                            print ("Update ProfileImage: Done")
                        }
                    } )
                }
            } )
        })
    }
    
    func getProfileImage(profileImageUrl: String, handler: @escaping ((UIImage)->())) { // Still not working
        let storageRef = Storage.storage().reference(forURL: profileImageUrl)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print(error.localizedDescription)
          }
            let image = UIImage(data: data!) ?? UIImage()
            print("get data")
                 DispatchQueue.main.async {
                     self.data = data
                     print(self.data!)
                     print("loaded profile image:", image as
                         Any)
                    
            handler(image)
            }
        }
    }
    
    // ---------------- Other User|s ---------------- //
    
    func getOtherUsers() {
        self.otherUsers = []
        let rootRef = Database.database().reference(withPath: Strings.urlIdentifierUser)
        rootRef.observe(.value, with: { (snapshot) in
            for uid in (snapshot.value as? NSDictionary)!.allKeys as! [String] {
                if (uid != self.sessionUser?.uid && !(self.sessionUser?.contacts.contains(uid))! && !(self.sessionUser?.likedUsers.contains(uid))!) {
                    self.getOtherUser(uid: uid)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getOtherUser(uid: String?) {
        var user: User = User(uid: uid!, email: "")
        let rootRef = Database.database().reference(withPath: Strings.urlIdentifierUser).child(uid.unsafelyUnwrapped)
        rootRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?[Strings.displayName] as? String ?? ""
            let fieldOfStudy = value?[Strings.fieldOfStudy] as? String ?? ""
            let description = value?[Strings.description] as? String ?? ""
            let hashtags = value?[Strings.hashtags] as? String ?? ""
            let profileImageUrl = value?[Strings.profileImageUrl] as? String ?? ""
            user.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
            user.updatePicture(profileImageUrl: profileImageUrl)
            self.otherUsers.append(user)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    // ---------------- Like and Match ---------------- //
    
    func addLikedUser(uid: String) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.sessionUser?.likedUsers.append(uid)
        let dict: Dictionary<String, Any> = [
            Strings.likedUsers: self.sessionUser?.likedUsers ?? ""
        ]
        Database.database().reference().child(Strings.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                print ("Added likedUser")
                self.checkIfLikedUserLikedYou(otherUserUid: uid)
                self.getOtherUsers()
            }
        } )
    }
    
    private func checkIfLikedUserLikedYou(otherUserUid: String) {
        let rootRef = Database.database().reference(withPath: Strings.urlIdentifierUser).child(otherUserUid)
        rootRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let otherUserLikedUsers = value?[Strings.likedUsers] as? [String] ?? []
            var otherUserContacts = value?[Strings.contacts] as? [String] ?? []
            if (otherUserLikedUsers.contains(self.sessionUser!.uid)) {
                self.sessionUser?.contacts.append(otherUserUid)
                otherUserContacts.append(self.sessionUser!.uid)
                let tempLikes1: [String] = self.sessionUser!.likedUsers
                self.sessionUser?.likedUsers = []
                for likedUser in tempLikes1 {
                    if(likedUser != otherUserUid) {
                        self.sessionUser?.likedUsers.append(otherUserUid)
                    }
                }
                let tempLikes2: [String] = otherUserLikedUsers
                var otherUserLikedUsers: [String] = []
                for likedUser in tempLikes2 {
                    if(likedUser != self.sessionUser?.uid) {
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
            Strings.likedUsers: likedUsers,
            Strings.contacts: contacts
        ]
        Database.database().reference().child(Strings.urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                print ("Match!")
            }
        } )
    }
    
    
    // ---------------- only development ---------------- //
    func deleteData(uid: String, deleteLikes: Bool) {
        var dict: Dictionary<String, Any>
        if deleteLikes {
            dict = [
                 Strings.likedUsers: [],
                 Strings.contacts: []
             ]
        } else {
            dict = [
                 Strings.contacts: []
             ]
        }
        Database.database().reference().child(Strings.urlIdentifierUser).child(uid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {
                print ("Deleted!")
            }
        } )
    }
}
