//
//  NoOtherUsersView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 18.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct NoOtherUsersView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(uiImage: UIImage(systemName: "tortoise.fill") ?? UIImage())
                    .frame(width: 300, height: 400)
                    .scaledToFit()
                    .background(Color.lmuLightGrey)
                    .overlay(
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom))
                            .clipped()
                ).cornerRadius(12.0)
                    .shadow(radius: 12.0)
                Text("no possible StudyBuddy")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }.padding()
            Spacer()
        }
    }
}

struct NoOtherUsersView_Previews: PreviewProvider {
    static var previews: some View {
        NoOtherUsersView()
    }
}
