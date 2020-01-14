//
//  StudyBuddySwiftUi
//
//  Created by Lorenz on 14.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    static let lmuGreen = Color("LMU Green")
    static let lmuLightGrey = Color("LMU Light Grey")
    static let lmuDarkGrey = Color("LMU Dark Grey")
}

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

// ------- Level 1 - Views: LoginView, ChangePasswordView, RegisterView, ResetPasswordView ------ //

public struct StudyBuddyTitleStyleLevel1a : ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.white)
    }
}

public struct StudyBuddyTitleStyleLevel1b : ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.lmuLightGrey)
    }
}

public struct StudyBuddyTextStyleLevel1a : ViewModifier {
    public func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
    }
}

public struct StudyBuddyTextStyleLevel1b : ViewModifier {
    public func body(content: Content) -> some View {
        content
            .foregroundColor(Color.lmuLightGrey)
    }
}

public struct StudyBuddyTextStyleLevel1c : ViewModifier {
    public func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
    }
}

public struct StudyBuddyTextFieldStyleLevel1 : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
            .padding(.horizontal, 50)
    }
}

public struct StudyBuddyButtonStyleLevel1: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 100, maxWidth: 200)
            .padding()
            .foregroundColor(.white)
            .background(Color.lmuDarkGrey)
            .cornerRadius(25)
            .padding(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

// ------- Level 2 - all other Views ------- //

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

public struct StudyTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
            .padding(.horizontal, 50)
    }
}
