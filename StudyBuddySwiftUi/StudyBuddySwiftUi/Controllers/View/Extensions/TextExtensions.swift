//
//  TextExtensions.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 23.01.20.
//  Copyright © 2020 Annika Jung. All rights reserved.
//

import SwiftUI

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
