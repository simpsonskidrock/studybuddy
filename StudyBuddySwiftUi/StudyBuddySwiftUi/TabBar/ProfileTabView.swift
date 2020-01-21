//
//  ProfileTabView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileTabView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    
    @State private var displayName: String = ""
    @State private var fieldOfStudy: String = ""
    @State private var description: String = ""
    @State private var hashtags: String = ""
    @State private var profileImageUrl: String = ""
    
    @State private var editProfile: Bool = false
    
    @State private var isShowingImagePicker: Bool = false
    @State var showAction: Bool = false
    
    @State private var image: UIImage = UIImage()
    
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Change profile image"),
            message: Text(""),
            buttons: [
                .default(Text("Change image"), action: {
                    self.showAction = false
                    self.isShowingImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove image"), action: {
                    self.showAction = false
                    self.session.deleteProfilePic()
                    self.image = UIImage()
                })
        ])
    }
    
    private func initialize() {
        if (self.session.sessionUser == nil) {
            self.session.listen(handler: { user in
                self.session.sessionUser = user
                self.displayName = user.displayName ?? ""
                self.fieldOfStudy = user.fieldOfStudy ?? ""
                self.description = user.description ?? ""
                self.hashtags = user.hashtags ?? ""
                self.profileImageUrl = user.profileImageUrl ?? ""
                if (self.profileImageUrl.isEmpty){
                    self.image = UIImage(systemName: "person.circle.fill")!
                } else {
                    self.session.getProfileImage(profileImageUrl: self.profileImageUrl, handler: { (image) in
                        DispatchQueue.main.async{
                            self.image = image
                        }
                    })
                }
            })
        } else {
            self.displayName = self.session.sessionUser?.displayName ?? ""
            self.fieldOfStudy = self.session.sessionUser?.fieldOfStudy ?? ""
            self.description = self.session.sessionUser?.description ?? ""
            self.hashtags = self.session.sessionUser?.hashtags ?? ""
            self.profileImageUrl = self.session.sessionUser?.profileImageUrl ?? ""
            if (self.profileImageUrl.isEmpty){
                self.image = UIImage(systemName: "person.circle.fill")!
            } else {
                self.session.getProfileImage(profileImageUrl: self.profileImageUrl, handler: { (image) in
                    DispatchQueue.main.async{
                        self.image = image
                    }
                })
            }
        }
    }
    
    private func leaveView() {
        self.editProfile = false
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    HStack {
                        Text("Profile")
                            .fontWeight(.semibold)
                            .textStyle(StudyBuddyTitleStyleLevel2())
                        Spacer()
                        HStack {
                            Button(action: {
                                self.session.signOut()
                                self.mode.wrappedValue.dismiss()
                            }){
                                HStack {
                                    Image(systemName: "arrow.uturn.left")
                                    Text("Logout")
                                        .fontWeight(.semibold)
                                }
                            }.buttonStyle(StudyBuddyIconButtonStyleLevel2())
                        }.padding()
                    }.frame(height: 50)
                        .padding(.leading, 10)
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle()
                            .stroke(Color.white, lineWidth: 5)
                    )
                    if self.editProfile {
                        Button(action: {
                            if (self.image == UIImage(systemName: "person.circle.fill")){
                                self.isShowingImagePicker.toggle()
                            }
                            else {
                                self.showAction = true
                            }
                        }) {
                            Image(systemName: "camera.on.rectangle")
                        }.buttonStyle(StudyBuddyIconButtonStyleLevel2())
                            .sheet(isPresented: $isShowingImagePicker, content: {
                                ImagePickerViewController(isPresented: self.$isShowingImagePicker, selectedImage: self.$image)
                            })
                            .actionSheet(isPresented: $showAction) {
                                sheet
                        }
                    }
                    VStack {
                        HStack {
                            if (editProfile) {
                                Text("Name:")
                                    .foregroundColor(.lmuLightGrey)
                                    .fontWeight(.bold)
                            }
                            TextField("Enter your name", text:  $displayName)
                                .disableAutocorrection(true)
                                .disabled(!self.editProfile)
                                .textFieldStyle(StudyBuddySubTitleStyleLevel2a())
                        }
                        HStack {
                            if (editProfile) {
                                Text("Field Of Study:")
                                    .foregroundColor(.lmuLightGrey)
                                    .fontWeight(.bold)
                            }
                            TextField("ex: Informatik", text:  $fieldOfStudy)
                                .disabled(!self.editProfile)
                                .textFieldStyle(StudyBuddySubTitleStyleLevel2a())
                        }
                        VStack(alignment: .leading){
                            Text("Description:")
                                .foregroundColor(.lmuLightGrey)
                                .fontWeight(.bold)
                            TextField("Describe your self", text: $description)
                                .disabled(!self.editProfile)
                                .textFieldStyle(StudyBuddySubTitleStyleLevel2b())
                        }
                        VStack(alignment: .leading){
                            Text(self.editProfile ? "Hashtags (Up to 6 tags)" : "Hashtags:")
                                .foregroundColor(.lmuLightGrey)
                                .fontWeight(.bold)
                            TextField("", text: $hashtags)
                                .lineLimit(nil)
                                .disabled(!self.editProfile)
                                .textFieldStyle(StudyBuddySubTitleStyleLevel2b())
                        }
                    }.padding()
                }
                Spacer()
                if !self.editProfile {
                    Button(action: {
                        self.editProfile.toggle()
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit").fontWeight(.semibold)
                        }
                    }.buttonStyle(StudyBuddyIconButtonStyleLevel2())
                }
                if self.editProfile {
                    Button(action: {
                        self.session.updateProfile(displayName: self.displayName, fieldOfStudy: self.fieldOfStudy, description: self.description, hashtags: self.hashtags, image: self.image)
                        self.editProfile.toggle()
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Save").fontWeight(.semibold)
                        }
                    }.buttonStyle(StudyBuddyIconButtonStyleLevel2())
                }
            }
        }.navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear(perform: initialize)
            .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .onDisappear(perform: leaveView)
    }
}
