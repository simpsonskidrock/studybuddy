//
//  RegisterView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State var resetPass = false

    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        ZStack {
          VStack(spacing: 16) {
               Text("Change Password").font(.largeTitle)
                .foregroundColor(.lmuLightGrey)
                Spacer()
                
                   
            VStack {
                Text("Create a new Password").foregroundColor(Color.white)
            
                TextField("New password", text: $newPassword)
                .textFieldStyle(StudyTextFieldStyle())
                .padding(.horizontal, 50)
                TextField("Confirm your password", text: $confirmPassword)
            .textFieldStyle(StudyTextFieldStyle())
                .padding(.horizontal, 50)
               
            }
                    Button(action: {
                       self.registered.toggle()
                    }) {
                        Text("Reset Password")
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                       }.buttonStyle(StudyButtonStyle())
                      .sheet(isPresented: $resertPass) {
                        GeneralTabView()
            }
           
            
            Spacer()
                    Spacer()
                
                Spacer()
            }
            .padding(.horizontal)
          .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
        }
        }
        
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

