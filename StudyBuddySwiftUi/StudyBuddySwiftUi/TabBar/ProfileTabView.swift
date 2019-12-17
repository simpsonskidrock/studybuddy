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
    @ObservedObject var locationManager = LocationManager()
    
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
                    self.image = UIImage(systemName: "person.circle.fill")!
                })
            ])

    }
    
    
    private func initialize() {
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
            self.session.getOtherUsers()
        })
    }
    
    private func leaveView() {
        self.editProfile = false
       /* self.displayName = self.session.sessionUser!.displayName ?? ""
        self.fieldOfStudy = self.session.sessionUser!.fieldOfStudy ?? ""
        self.description = self.session.sessionUser!.description ?? ""
        self.hashtags = self.session.sessionUser!.hashtags ?? ""
        self.profileImageUrl = self.session.sessionUser!.profileImageUrl ?? "" */
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    HStack {
                        Text("Profile")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                        Spacer()
                        HStack {
                            Image(systemName: "gear").contextMenu {
                                Button(action: {
                                    self.session.searchWithGPS.toggle()
                                }) {
                                    Text("Search with Location")
                                    if self.session.searchWithGPS {
                                        Image(systemName: "location")
                                    } else {
                                        Image(systemName: "location.slash")
                                    }
                                }
                                Button(action: {
                                    self.session.signOut()
                                    self.mode.wrappedValue.dismiss()
                                }){
                                    HStack {
                                        Image(systemName: "arrow.uturn.left")
                                        Text("Logout")
                                            .fontWeight(.semibold)
                                    }
                                }
                            }.padding()
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                        }
                        
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
                                .foregroundColor(.white)
                        }.padding()
                            .sheet(isPresented: $isShowingImagePicker, content: {
                                ImagePickerViewController(isPresented: self.$isShowingImagePicker, selectedImage: self.$image)
                            })
                        .actionSheet(isPresented: $showAction) {
                            sheet
                        }
                    }
                    VStack {
                        HStack {
                            Text("Name:")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                            TextField("Enter your name", text:  $displayName)
                                .disableAutocorrection(true)
                                .disabled(!self.editProfile)
                                .textFieldStyle(StudyTextFieldLightStyle())
                        }
                        HStack {
                            Text("Field Of Study:")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                            TextField("ex: Informatik", text:  $fieldOfStudy)
                                .disabled(!self.editProfile)
                                .textFieldStyle(StudyTextFieldLightStyle())
                        }
                        Text("Description")
                            .foregroundColor(.black)
                        TextField("Describe your self", text: $description)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(5)
                            .disabled(!self.editProfile)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.lmuLightGrey)
                        Text("Hashtags").foregroundColor(.black)
                        TextField("#", text: $hashtags).lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .disabled(!self.editProfile)
                            .textFieldStyle(StudyTextFieldLightStyle())
                    }.padding()
                }
                Spacer()
                if !self.editProfile {
                    Button(action: {
                        self.editProfile.toggle()
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 15))
                            Text("Edit").fontWeight(.semibold)
                        }
                    }.buttonStyle(StudyButtonLightStyle())
                }
                if self.editProfile {
                    Button(action: {
                        self.session.updateProfile(displayName: self.displayName, fieldOfStudy: self.fieldOfStudy, description: self.description, hashtags: self.hashtags, image: self.image)
                        self.editProfile.toggle()
                    }) {
                        Text("Save").fontWeight(.semibold)
                    }.buttonStyle(StudyButtonLightStyle())
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
