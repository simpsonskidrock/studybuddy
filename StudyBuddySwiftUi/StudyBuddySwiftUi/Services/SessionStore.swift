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
    
    // Profile Changes //
    
<<<<<<< HEAD
    func addProfile(result: AuthDataResult?, image: UIImage?) {
        
        guard let imageSelected = image else{
            print("Image is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4)else{
            return
        }
 
=======
    func getProfile (uid: String?) -> User? {
        let rootRef = Database.database().reference(withPath: "Users").child(uid.unsafelyUnwrapped).observe(.value, with: { snapshot in
          // This is the snapshot of the data at the moment in the Firebase database
          // To get value from the snapshot, we user snapshot.value
            print(snapshot.value.unsafelyUnwrapped as Any)
        })
>>>>>>> ee61b1d83f8f15966558bf109339104d6dd59902
        
        let displayNameRef: String = self.getRef(uid: uid, text: "displayName")
        let emailRef: String = self.getRef(uid: uid, text: "email")
        let fieldOfStudyRef: String = self.getRef(uid: uid, text: "fieldOfStudy")
        let descriptionRef: String = self.getRef(uid: uid, text: "desciption")
        let hashtagsRef: String = self.getRef(uid: uid, text: "hashtags")
        let user = User(uid: uid.unsafelyUnwrapped, email: emailRef)
        user.updateDetails(displayName: displayNameRef, fieldOfStudy: fieldOfStudyRef, description: descriptionRef, hashtags: hashtagsRef)
        return user
    }
    
    private func getRef(uid: String?, text: String) -> String {
        let rootRef = Database.database().reference(withPath: "Users").child(uid.unsafelyUnwrapped).child(text).observe(.value, with: { snapshot in
            print(snapshot.value.unsafelyUnwrapped as Any)
        })
        print("#", rootRef)
        return ""
    }
    
    func addProfile(result: AuthDataResult?) {
        if let authData = result {
            print(authData.user.email!)
            var dict: Dictionary<String, Any> = [
                "uid": authData.user.uid,
<<<<<<< HEAD
                "email": authData.user.email!,
                "profileImageUrl": "",
                "fieldOfStudy": "",
                "description": "",
                "hashtags": ""
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
                                     .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                                         (error, ref) in
                                         if error == nil {
                                             print ("Done")
                                         }
                                     } )
=======
                "email": authData.user.email!
            ]
            Database.database().reference().child("Users")
                .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        print ("Done")
>>>>>>> ee61b1d83f8f15966558bf109339104d6dd59902
                    }
                })
            })
          
         
        }
    }
    
    func updateProfile (displayName: String?, fieldOfStudy: String?, description: String?, hashtags: String?) {
        
        /* guard let imageSelected = self.image else{
         print("Avatar is nil")
         return
         }
         guard let imageData = imageSelected.jpegData(compressionQuality: 0.4)else{
         return
         }
         */
        
        self.sessionUser?.updateDetails(displayName: displayName, fieldOfStudy: fieldOfStudy, description: description, hashtags: hashtags)
        // send update to database
        let tempUid: String = String((self.sessionUser?.uid)!)
        let dict: Dictionary<String, Any> = [
            "displayName": displayName ?? "",
            "fieldOfStudy": fieldOfStudy ?? "",
            "description": description ?? "",
            "hashtags": hashtags ?? ""
        ]
        Database.database().reference().child("Users")
            .child(tempUid).updateChildValues(dict, withCompletionBlock: {
                (error, ref) in
                if error == nil {
                    print ("Done")
                }
            } )
    }
    
    // uploading Images //
    
    func uploadImage (imageName: String) {
     /*   let data = Data()
        let riversRef = storageRef.child("images/" + imageName + ".jpg")
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
          if let error = error {
            return
          }
          reference.downloadURL(completion: { (url, error) in
            if let error = error { return }
          })
        } */
    }
    
    // get all other Users
    
    func getAllOtherUsers() {
        
    }
}
