//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()
    
    // for the registerButton TODO rename
    @State private var isActive: Bool = false
    
    
    @State private var errorDialogVisible: Bool = false
    @State private var tempAlert: Alert = nil
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    @State private var isShowingImagePicker: Bool = false
    @State private var image: UIImage = UIImage()
    
    func isDataValid() -> Bool {
        if (self.email == "" || self.password == "" || self.repeatPassword == "") {
            self.tempAlert = Alert.alertEmptyField
            return false
        } else if (self.password.count < 6 || self.repeatPassword.count < 6) {
            self.tempAlert = Alert.alertTooShortPassword
            return false
        } else if (self.password != self.repeatPassword) {
            self.tempAlert = Alert.alertUnequalPassword
            return false
        }
        return errorDialogVisible
    }
    
    func signUp () {
        if (!self.isDataValid()) {
            session.signUp(email: email, password: password) {(error) in
                if error != nil {
                    print(error!.localizedDescription)
                    self.tempAlert = Alert.alertIncorrectData
                } else {
                    // TODO Switch to Generel Tab View
                    self.isActive.toggle()
                }
            }
        } else {
            // show error dialog
            errorDialogVisible = true
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    Text("SignUp").font(.largeTitle)
                        .foregroundColor(.lmuLightGrey)
                    Spacer()
                    Text(Strings.appName).font(.largeTitle)
                        .foregroundColor(Color.white)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    //                        .frame(width: 100, height: 100))
                    Button(action: {
                        self.isShowingImagePicker.toggle()
                    }, label: {
                        Text("Select Image")
                            .font(.system(size: 15)).foregroundColor(.white)
                    }) .sheet(isPresented: $isShowingImagePicker, content: {
                        ImagePickerViewController(isPresented: self.$isShowingImagePicker, selectedImage: self.$image)
                        // Text("this is the image picker")
                    }).padding()
                }
                VStack {
                    Text("Create a new Account").foregroundColor(Color.white).font(.title)
                    TextField("E-mail", text: $email)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(StudyTextFieldStyle())
                    SecureField("Confirm Password", text: $repeatPassword)
                        .textFieldStyle(StudyTextFieldStyle())
                }
                Group {
                    Spacer()
                    
                    Button(action: {
                        self.signUp()
                    }) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())
                    
                    // Phantom navigation link:
                    NavigationLink("", destination: GeneralTabView(), isActive: self.$isActive)
                    
                }
//                NavigationLink(destination: {
//                    VStack {
//                        if loginSuccess {
//                            GeneralTabView()
//                        } else {
//                            // Not going to GeneralTabView
//                            RegisterView()
//                        }
//                    }
//                }()) {
//                    Text("Register")
//                }.buttonStyle(StudyButtonStyle())
//                    .simultaneousGesture(TapGesture().onEnded{self.signUp()})
//
                
                HStack {
                    Text("Already have an account?").foregroundColor(Color.lmuLightGrey)
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Text("Sign In").foregroundColor(.white)
                    }
                }
                Group {
                Spacer()
                Spacer()
                }
            }.padding(.horizontal)
                .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
                .padding(.bottom, keyboard.currentHeight)
                .edgesIgnoringSafeArea(.bottom)
                .animation(.easeOut(duration: 0.16))
                .alert(isPresented: $errorDialogVisible) {
                    self.tempAlert.unsafelyUnwrapped
            }
        }
        .navigationBarTitle("Sign Up")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
