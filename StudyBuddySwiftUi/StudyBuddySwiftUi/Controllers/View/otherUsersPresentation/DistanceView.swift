//
//  DistanceView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 22.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct DistanceView: View {
    let userModel: UserModel
    
    var body: some View {
        HStack {
            if self.userModel.distance != nil {
                if self.userModel.distance!  >= 201.0 {
                    Image(systemName: "location.slash")
                    Text("no GPS")
                } else if self.userModel.distance! == 200.0 {
                    Image(systemName: "location")
                    Text("over 200km")
                } else if self.userModel.distance! >= 10.0 {
                    Image(systemName: "location")
                    Text("\(String(format: "%.0f", self.userModel.distance!))km")
                } else if self.userModel.distance! >= 1.0 {
                    Image(systemName: "location")
                    Text("\(String(format: "%.1f", self.userModel.distance!))km")
                } else {
                    Image(systemName: "location")
                    Text("\(String(format: "%.0f", self.userModel.distance!*1000))m")
                }
            }
        }
        .foregroundColor(.white)
        .background(Color.lmuGreen)
    }
}
