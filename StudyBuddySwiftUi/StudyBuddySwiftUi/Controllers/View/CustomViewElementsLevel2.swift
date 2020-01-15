//
//  CustomViewElementsLevel2.swift
//  StudyBuddySwiftUi
//
//  Created by Lorenz on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

// ------- Level 2 - all Views after authentification ------- //

public struct StudyBuddyTitleStyleLevel2 : ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.white)
    }
}

public struct StudyBuddySubTitleStyleLevel2a : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.largeTitle)
            .foregroundColor(Color.white)
    }
}

public struct StudyBuddySubTitleStyleLevel2b : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.white)
            .lineLimit(5)
            .multilineTextAlignment(.leading)
            .font(.system(size: 16))
            .fixedSize(horizontal: false, vertical: true)
    }
}

public struct StudyBuddyIconButtonStyleLevel2: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .font(.system(size: 15))
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)

    }
}
