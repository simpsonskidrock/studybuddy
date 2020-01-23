//
// Created by Lorenz on 21.01.20.
// Copyright (c) 2020 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

// author: Lorenz
// Extend button so it acts like a toggleable button that changes background color when it's activated / deactivated

struct HashtagButton: View {
    @EnvironmentObject var session: SessionStore
    let tag: String

    var body: some View {
        if self.session.activeFilterTags.contains(tag) {
            return Button(action: {
                self.session.updateFilter(tag: self.tag)
            }) {
                Text(tag).foregroundColor(Color.lmuLightGrey)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.lmuDarkGrey))
                    .shadow(color: .black, radius: 3)
            }
        } else {
            return Button(action: {
                self.session.updateFilter(tag: self.tag)
            }) {
                Text(tag).foregroundColor(Color.white)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.lmuLightGrey))
                    .shadow(color: .black, radius: 3)
            }
        }
    }
}
