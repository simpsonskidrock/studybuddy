//
//  EditProfileView.swift
//  StudyBuddySwiftUi
//
//  Created by Liliane Kabboura on 20.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var mode
    @State var name = ""
    @State var fieldOfStudy = ""
    @State var description = ""
    @State var hashtag = ""
    
    
    var body: some View {
        
        VStack{
            HStack{
                Text( "Edit profile")
                    .foregroundColor(.lmuLightGrey)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                
                Spacer()
                
        
                
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }){
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                    
                    
                }.foregroundColor(.lmuLightGrey)
                    .padding()
                
                
            }.frame(height: 50)
                .padding(.leading, 10)
            
            VStack{
                Text("StudyBuddy").font(.largeTitle).foregroundColor(Color.white)
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .colorInvert()
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 150, height: 150))
                    .padding(.vertical, 35)
                Spacer()
                
                HStack{
                    Text("Name:")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextField("Enter You name", text:  $name)
                    
                }
                HStack{
                    Text("Field Of Study")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    TextField("ex: Informatik", text:  $fieldOfStudy)
                    
                }
                VStack{
                    
                    ScrollView(.vertical) {
                        Text("Description / Characteristics").foregroundColor(.black)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        TextField("Describe your self", text: $description)
                        
                    }
                    ScrollView(.vertical) {
                        Text("Hashtags").foregroundColor(.black)
                        TextField("#", text: $hashtag)
                        
                        
                    }
                }
            }
            
            Button(action: {
               // NavigationLink(destination: GeneralTabView())
            }) {
                
                
                Text("Save")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                
            }.padding()
                
                .foregroundColor(.lmuLightGrey)
            
        } .padding(.horizontal)
            .background(Color.lmuGreen.edgesIgnoringSafeArea(.vertical))
            .navigationBarTitle("Profil")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
