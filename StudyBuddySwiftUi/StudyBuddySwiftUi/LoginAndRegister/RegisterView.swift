//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI
import Firebase

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

struct RegisterView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var keyboard = KeyboardResponder()
    
    // for the registerButton TODO rename
    @State private var signUpSuccessFlagForView: Bool = false
    @State private var errorText: String = ""
    
    
    @State private var errorDialogVisible: Bool = false
    @State private var tempAlert: Alert = nil
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    
    @State private var isShowingImagePicker: Bool = false
    @State private var image: UIImage = UIImage()
    
    enum RegisterDataValidity: String {
        case invalidEmail = "Invalid Email"
        case shortPassword = "Password too short"
        case unequalPasswords = "Passwords don't match"
        case valid = ""
    }
    
    
    
    func isDataValid() -> RegisterDataValidity {

        if (self.email == "" || self.password == "" || self.repeatPassword == "") {
            return RegisterDataValidity.invalidEmail
        } else if (!email.matches("[^@]+@[^\\.]+\\..+")) {
            return RegisterDataValidity.invalidEmail
        } else if (self.password.count < 6 || self.repeatPassword.count < 6) {
            return RegisterDataValidity.shortPassword
        } else if (self.password != self.repeatPassword) {
            return RegisterDataValidity.unequalPasswords
        }
        return RegisterDataValidity.valid
    }
    
    /**
     checks Data and handles correct Alert in case
     */
    func signUp() -> Bool {
        var success = false
        if (self.isDataValid() == RegisterDataValidity.valid) {
            session.signUp(email: email, password: password) {(error) in
                if error != nil {
                    print(error!.localizedDescription)
                    success = false
                } else {
                    success = true
                }
            }
        } else {
            success = false
        }
        return success
    }
    
    var body: some View {
        
        let repeatPasswordBinding = Binding<String>(get: {
            self.repeatPassword
        }, set: {
            self.repeatPassword = $0
            self.errorText = self.isDataValid().rawValue
        })
        
        return ZStack {
            VStack {
                Group {
                    Text("SignUp").font(.largeTitle)
                        .foregroundColor(.lmuLightGrey)
                    Spacer()
                    Text(FixedStringValues.appName).font(.largeTitle)
                        .foregroundColor(Color.white)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
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
                    SecureField("Confirm Password", text: repeatPasswordBinding)
                        .textFieldStyle(StudyTextFieldStyle())
                }
                Group {
                    Spacer()
                    Text(errorText).foregroundColor(Color.red)
                    Spacer()
                    
                    Button(action: {
                        self.signUpSuccessFlagForView = self.signUp()
                    }) {
                        Text("Register")
                    }.buttonStyle(StudyButtonStyle())
                    
                    // Phantom navigation link:
                    NavigationLink("", destination: GeneralTabView(), isActive: self.$signUpSuccessFlagForView)
                    
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
                .offset(x: 0, y: -keyboard.currentHeight)
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
