//
//  UserView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct UserView: View {
    let userModel: User
    
    func getImage() -> UIImage {
        print(self.userModel.uid)
        return UIImage()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            AvatarView(image: self.getImage())
            NameView(name: userModel.displayName!, fieldOfStudy: userModel.fieldOfStudy!, description: userModel.description!, hashtags: userModel.hashtags!)
        }
        .shadow(radius: 12.0)
        .cornerRadius(12.0)
    }
}
