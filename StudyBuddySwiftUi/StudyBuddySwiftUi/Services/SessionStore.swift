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
    var myHashtags: String = ""
    // hashtags to filter by divided by a space
    var tagsToFilterBy: [String] = []

    func appendFilter(newTag: String) {
        tagsToFilterBy.append(newTag)
        printFilters()
    }
    func removeFilter(tag: String) {
        tagsToFilterBy = tagsToFilterBy.filter{$0 != tag}
        printFilters()
    }

    func printFilters() {
        print("[", terminator:"")
        for tag in tagsToFilterBy {
            print(tag, terminator:" ")
        }
        print("]")
    }

    private func isUserPartOfFilter(user: UserModel) -> Bool {
        if (tagsToFilterBy.count < 1) {
            return true
        }

        let userTags = user.hashtags?.components(separatedBy: " ") ?? []

        // compare elements of both array to each other and if at least one matches the other,
        // the given user is part of the search
        for filterTag in tagsToFilterBy {
            for userTag in userTags {
                // standardize
                let userTagMod = userTag.lowercased().replacingOccurrences(of: "#", with: "")
                let filterTagMod = filterTag.lowercased().replacingOccurrences(of: "#", with: "")
                
                if userTagMod == filterTagMod {
                    return true
                }
            }
        }
        return false
    }

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
    
    /**
     * Clear some variable for no unauthorized access (after logout then login of other user)
     * otherwise these variables are still be set before the data of the new user has been downloaded
     */
    private func clearProfile() {
        self.otherUsers = []
        self.likedUsers = []
        self.matchedUsers = []
        self.searchWithGPS = false
        self.sessionUser = nil
    }
    
    // ---------------- Profile ---------------- //
    
    /**
     * Download a profile with a given uid
     * ( ! not only for getting the current users profile ! )
     * returns a UserModel with all entries of the database
     * in case of no gps usage: without location-entry
     */
    func getProfile(uid: String?, handler: @escaping ((UserModel) -> ())) {
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
            let gpsUsage = value?[FixedStringValues.gpsUsage] as? Bool ?? false
            var tempUser: UserModel = UserModel(uid: uid, email: email)
            if gpsUsage {
                rootRef.child(FixedStringValues.location).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let latitude = value?[FixedStringValues.latitude] as? Double ?? 0.0
                    let longitude = value?[FixedStringValues.longitude] as? Double ?? 0.0
                    let location: LocationModel = LocationModel(latitude: latitude, longitude: longitude)
                    tempUser.updateCompleteProfile(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags, profileImageUrl: profileImageUrl, likedUsers: likedUsers, contacts: contacts, gpsUsage: gpsUsage, location: location)
                    handler(tempUser)
                })
            } else {
                tempUser.updateCompleteProfile(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags, profileImageUrl: profileImageUrl, likedUsers: likedUsers, contacts: contacts, gpsUsage: gpsUsage, location: nil)
                handler(tempUser)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /**
     * Create a new user
     * used for registration
     */
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
    
    /**
     * Upload some data from current user which the user can edit:
     * displayName, fieldOfStudy, description, hashtags
     */
    func updateProfile(displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?, image: UIImage?) {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.updateProfileImage(uid: tempUid, image: image)

        // Save fomatted hashtags without # symbols
        self.myHashtags = hashtags?.replacingOccurrences(of: "#", with: "") ?? ""
        self.myHashtags = self.myHashtags.replacingOccurrences(of: "  ", with: " ")

        let dict: Dictionary<String, Any> = [
            FixedStringValues.displayName: displayName ?? "",
            FixedStringValues.fieldOfStudy: fieldOfStudy ?? "",
            FixedStringValues.description: description ?? "",
            FixedStringValues.hashtags: self.myHashtags ?? ""
        ]

        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                self.sessionUser?.updateDetails(displayName: displayName!, fieldOfStudy: fieldOfStudy!, description: description!, hashtags: self.myHashtags)
                print("Update ProfileDetails: Done")
            }
        })
    }
    
    // ---------------- Image ---------------- //
    
    /**
     * Upload the new profile image of the current user to Firebase Storage
     * Add link to the profile image in Firebase Storage to the current user UserModel
     */
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
    
    /**
     * Remove profile image of current user from Firebase Storage
     * and delete the url in the UserModel
     */
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
    
    /**
     * Download a profile image from a users profileImageUrl
     * ( !  used for all users ! )
     */
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
    
    /**
     * Get all users from database
     * split them into lists: otherUsers, likedUsers, matchedUsers
     * otherUsers: users which are not liked by the current user & users which are not matched with the current user
     * likedUsers: users which are liked by the current user
     * matchedUsers: users which are matched with the current user
     */
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
                                if !self.otherUsers.contains(user) && self.isUserPartOfFilter(user: user) {
                                    var tempUser = user
                                    if self.sessionUser?.gpsUsage ?? false {
                                        if user.gpsUsage ?? false {
                                            tempUser.updateDistance(distance: self.locationManager.getDistance(lat1: self.sessionUser!.location!.latitude as! Double, long1: self.sessionUser!.location!.longitude as! Double, lat2: user.location!.latitude as! Double, long2: user.location!.longitude as! Double)
                                            )
                                        } else {
                                            tempUser.updateDistance(distance: 201.0)
                                        }
                                    }
                                    self.otherUsers.append(tempUser)
                                    if self.sessionUser?.gpsUsage ?? false {
                                        self.otherUsers.sort {
                                            Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue($0.distance!)) < Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue($1.distance!))
                                        }
                                    }
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
    
    /**
     * Add a UserModel to the likedUsers (local) list and the uid of the UserModel to the sessionUser.likedUsers (local and database)
     */
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
    
    /**
     * Remove a userId from the likedUsers (list with uids) from current user
     * only local!
     * change in database with self.updateLikedUsersInDB
     */
    func removeLikedUser(uidToRemove: String) {
        let prevSize: Int = self.sessionUser?.likedUsers.count ?? 0
        self.sessionUser?.likedUsers = self.sessionUser?.likedUsers.filter{$0 != uidToRemove} ?? []
        if (prevSize > self.sessionUser?.likedUsers.count ?? 0) {
            print("Removal successful")
        } else {
            print("Removal failed! likedUsers:\(self.sessionUser?.likedUsers)")
        }
        self.updateLikedUsersInDB()
    }
    
    /**
    * Remove a userId from the matchedUsers (list with uids) from current user
    * only local!
    * change in database with self.updateMatchedUsersInDB
    */
    func removeMatchedUser(uidToRemove: String) {
        let prevSize: Int = self.sessionUser?.contacts.count ?? 0
        self.sessionUser?.contacts = self.sessionUser?.contacts.filter{$0 != uidToRemove} ?? []
        if (prevSize > self.sessionUser?.contacts.count ?? 0) {
            print("Removal successful")
        } else {
            print("Removal failed! contacts:\(self.sessionUser?.contacts)")
        }
        self.updateMatchedUsersInDB()
    }
    
    /**
     * Upload the current likedUsers (list with uids) from current user to database
     */
    func updateLikedUsersInDB() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.likedUsers: self.sessionUser?.likedUsers ?? ""
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {}
        } )
    }
    
    /**
     * Upload the current matchedUsers (list with uids) from current user to database
     */
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
    
    /**
     * Upload current gpsUsage state from current user
     * gpsUsage is true: self.updateLocation
     * gpsUsage is false: removeLocation
     */
    func updateGpsUsage() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            FixedStringValues.gpsUsage: self.sessionUser?.gpsUsage ?? false
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {}
        } )
        if self.searchWithGPS {
            self.updateLocation()
        } else {
            self.removeLocation()
        }
    }
    
    /**
     * Request for location of current user and outcome is stored in the database
     * ( location(latitude, longitude) )
     */
    func updateLocation() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.locationManager.requestLocation { (location) in
            self.sessionUser?.updateLocation(location: LocationModel(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            let dict: Dictionary<String, Any> = [
                FixedStringValues.latitude: self.sessionUser?.location?.latitude ?? "",
                FixedStringValues.longitude: self.sessionUser?.location?.longitude ?? ""
            ]
            Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).child(FixedStringValues.location).updateChildValues(dict, withCompletionBlock: {(error, ref) in
                if error == nil {}
            })
        }
    }
    
    /**
     * Remove location of current user (local and database)
     */
    func removeLocation() {
        let tempUid: String = String((self.sessionUser?.uid)!)
        self.sessionUser?.location = nil
        let dict: Dictionary<String, Any> = [
            FixedStringValues.location: self.sessionUser?.location
        ]
        Database.database().reference().child(FixedStringValues.urlIdentifierUser).child(tempUid).updateChildValues(dict, withCompletionBlock: {(error, ref) in
            if error == nil {}
        })
    }
}
