//
//  NameView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 29.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

struct NameView: View {
    let name: String
    let fieldOfStudy: String
    let description: String
    let hashtags: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("\(name), \(fieldOfStudy)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(description)
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundColor(.white)
            Text(hashtags)
                .font(.system(size: 16))
                .fontWeight(.regular)
                .foregroundColor(.white)
        }
        .padding()
    }
}
