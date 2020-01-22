//
//  LikeView.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 22.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

struct LikeView: View {
    var body: some View {
        let image = Image(systemName: "hand.thumbsup.fill").resizable().foregroundColor(Color.white).frame(width: 300, height: 300, alignment: .center).shadow(radius: 10.0)
        return image
    }
}
