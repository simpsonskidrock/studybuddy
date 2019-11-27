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
    
    @State var displayName: String = ""
    @State var fieldOfStudy: String = ""
    @State var description: String = ""
    @State var hashtags: String = ""
    
    @State private var editProfile = false
    
    @State var isShowingImagePicker = false
    @State var image = UIImage()
    
    func initialize() {
        self.displayName = session.sessionUser?.displayName ?? ""
        self.fieldOfStudy = session.sessionUser?.fieldOfStudy ?? ""
        self.description = session.sessionUser?.description ?? ""
        self.hashtags = session.sessionUser?.hashtags ?? ""
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        self.session.signOut()
                        self.mode.wrappedValue.dismiss()
                    }){
                        HStack {
                            Image(systemName: "arrow.uturn.left")
                                .font(.system(size: 15))
                            Text("Logout")
                                .fontWeight(.semibold)
                                .font(.system(size: 12))
                        }.foregroundColor(.lmuLightGrey)
                    }.padding()
                }.frame(height: 50)
                    .padding(.leading, 10)
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 150, height: 150))
                if self.editProfile { Button(action:{
                    self.isShowingImagePicker.toggle()
                }) {
                    Image(systemName: "camera.on.rectangle")
                        .foregroundColor(.lmuLightGrey)
                }.padding()
                    .sheet(isPresented: $isShowingImagePicker, content: {
                        ImagePickerViewController(isPresented: self.$isShowingImagePicker, selectedImage: self.$image)
                    })
                }
                VStack {
                    HStack {
                        Text("Name:")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        TextField("Enter your name", text:  $displayName)
                            .disableAutocorrection(true)
                            .disabled(!self.editProfile)
                            .foregroundColor(.lmuLightGrey)
                    }
                    HStack {
                        Text("Field Of Study:")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        TextField("ex: Informatik", text:  $fieldOfStudy)
                            .disabled(!self.editProfile)
                            .foregroundColor(.lmuLightGrey)
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
                        .foregroundColor(.lmuLightGrey)
                }.padding()
            }
            Spacer()
            if !self.editProfile { Button(action: {
                self.editProfile.toggle()
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 15))
                    Text("Edit")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                }
            }.padding()
                .foregroundColor(.lmuLightGrey)
            }
            if self.editProfile { Button(action: {
                self.session.updateProfile(displayName: self.displayName, fieldOfStudy: self.fieldOfStudy, description: self.description, hashtags: self.hashtags)
                self.editProfile.toggle()
            }) {
                Text("Save").fontWeight(.semibold)
                    .font(.system(size: 15))
            }.padding()
                .foregroundColor(.lmuLightGrey)
            }
        }.navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear(perform: initialize)
            .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
