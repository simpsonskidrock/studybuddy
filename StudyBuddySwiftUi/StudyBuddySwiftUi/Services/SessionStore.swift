//
//  CommunicationStore.swift
//  StudyBuddySwiftUi
//
//  Created by Manuel Suess on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase
import Combine
import os.log

class SessionStore: ObservableObject {
    @ObservedObject var locationManager = LocationManager()
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    var sessionUser: UserModel? {
        didSet {
            self.didChange.send(self)
        }
    }
    private var handle: AuthStateDidChangeListenerHandle?
    
    /* Users that haven't been interacted with (not liked, no match) */
    @Published var otherUsers: [UserModel] = []
    /* Users the currrentUser has liked */
    @Published var likedUsers: [UserModel] = []
    /* Users the currentUser has matched with */
    @Published var matchedUsers: [UserModel] = []
    var presentMatchAlert: Bool = false
    @Published var searchWithGPS: Bool = false
    var hashtags: String = ""

    func listen(handler: @escaping ((UserModel) -> ())) {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.sessionUser = UserModel(
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
            self.clearProfile()
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
    
    private func clearProfile() {
        self.otherUsers = []
        self.likedUsers = []
        self.matchedUsers = []
        self.sessionUser = nil
    }

    // ---------------- Profile ---------------- //

    func getProfile(uid: String?, handler: @escaping ((UserModel) -> ())) {
        let rootRef = Database.database().reference(withPath: FixedStringValues.urlIdentifierUser).child(uid!)
        rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let uid = value?[FixedStringValues.uid] as? String ?? ""
            let email = value?[FixedStringValues.email] as? String ?? ""
            let displayName = value?[FixedStringValues.displayName] as? String ?? ""
            let fieldOfStudy = value?[FixedStringValues.fieldOfStudy] as? String ?? ""
            let description = value?[FixedStringValues.description] as? String ?? ""
            self.hashtags = value?[FixedStringValues.hashtags] as? String ?? ""
            let profileImageUrl = value?[FixedStringValues.profileImageUrl] as? String ?? ""
            let likedUsers = value?[FixedStringValues.likedUsers] as? [String] ?? []
            let contacts = value?[FixedStringValues.contacts] as? [String] ?? []
            let gpsUsage = value?[FixedStringValues.gpsUsage] as? Bool ?? false
            var tempUser: UserModel = UserModel(uid: uid, email: email)
            tempUser.updateCompleteProfile(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: self.hashtags, profileImageUrl: profileImageUrl, likedUsers: likedUsers, contacts: contacts, gpsUsage: gpsUsage)
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
        // update tags for swipeView
        if let newTags = hashtags {
            self.hashtags = newTags
        } else {
            self.hashtags = ""
        }

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
    
    func deleteProfilePic() {
        guard let userUid = self.sessionUser?.uid else {
            return
        }
        
        let pictureRef = Storage.storage().reference().child("\(FixedStringValues.urlIdentifierProfile)/\(userUid)")
        pictureRef.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("profileimage is deleted")
            }
        }
        self.sessionUser?.profileImageUrl = ""
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
    
    func downloadAllUserLists() {
        self.otherUsers = []
        self.likedUsers = []
        self.matchedUsers = []
        var uids: [String] = []
        let rootRef = Database.database().reference(withPath: FixedStringValues.urlIdentifierUser)
        rootRef.observe(.value, with: { (snapshot) in
            for uid in (snapshot.value as? NSDictionary)!.allKeys as! [String] {
                if !uids.contains(uid) {
                    uids.append(uid)
                    if (uid != self.sessionUser?.uid) {
                        self.getProfile(uid: uid, handler: { user in
                            if (self.sessionUser?.contacts.contains(uid) ?? false) {
                                if !self.matchedUsers.contains(user) {
                                    self.matchedUsers.append(user)
                                }
                            } else if (self.sessionUser?.likedUsers.contains(uid) ?? false) {
                                if !self.likedUsers.contains(user) {
                                    self.likedUsers.append(user)
                                }
                            } else {
                                if !self.otherUsers.contains(user) {
                                    self.otherUsers.append(user)
                                }
                            }
                        })
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // ---------------- Likes and Contacts ---------------- //

    func addLikedUser(user: UserModel) {
        if !(self.sessionUser?.likedUsers.contains(user.uid) ?? false) {
            self.sessionUser?.likedUsers.append(user.uid)
            self.likedUsers.append(user)
            let tempUid: String = String((self.sessionUser?.uid)!)
            let dict: Dictionary<String, Any> = [
                FixedStringValues.likedUsers: self.sessionUser?.likedUsers ?? ""
            ]
            Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
                if error == nil {
                    self.getProfile(uid: self.sessionUser!.uid, handler: { user in
                        self.sessionUser = user
                        self.downloadAllUserLists()
                    })
                }
            } )
        }
    }

    func removeLikedUser(uidToRemove: String) {
        let prevSize: Int = self.sessionUser?.likedUsers.count ?? 0
        self.sessionUser?.likedUsers = self.sessionUser?.likedUsers.filter{$0 != uidToRemove} ?? []
        if (prevSize > self.sessionUser?.likedUsers.count ?? 0) {
            print("Removal successful")
        } else {
            print("Removal failed! likedUsers:\(self.sessionUser?.likedUsers)")
        }
        updateLikedUsersInDB()
    }

    func removeMatchedUser(uidToRemove: String) {
        let prevSize: Int = self.sessionUser?.contacts.count ?? 0
        self.sessionUser?.contacts = self.sessionUser?.contacts.filter{$0 != uidToRemove} ?? []
        if (prevSize > self.sessionUser?.contacts.count ?? 0) {
            print("Removal successful")
        } else {
            print("Removal failed! contacts:\(self.sessionUser?.contacts)")
        }
        updateMatchedUsersInDB()
    }

    func updateLikedUsersInDB() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.likedUsers: self.sessionUser?.likedUsers ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {}
        } )
    }

    func updateMatchedUsersInDB() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.contacts: self.sessionUser?.contacts ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {}
        } )
    }
    
    // ---------------- Location ---------------- //
    
    func updateGpsUsage() {
        print("update")
        let tempUid: String = String((self.sessionUser?.uid)!)
        print(tempUid)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.gpsUsage: self.sessionUser?.gpsUsage ?? false
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {}
        } )
    }
    
    func updateLocation() {
        locationManager.requestLocation { (location) in
            print ("LocationStatus: \(self.locationManager.statusString)")
            print ("latitude: \(location.coordinate.latitude)")
            print ("longtitude: \(location.coordinate.longitude)")
        }
        //TODO: save location to DB
        //Database.database().reference().child("Location").child(self.session.sessionUser!.uid).setValue(["Latitude: \(location.coordinate.latitude)", "Longitude: \(location.coordinate.longitude)" ])
        
    }
}
