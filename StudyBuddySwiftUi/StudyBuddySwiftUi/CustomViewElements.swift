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

public struct StudyTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

public struct StudyButtonStyle: ButtonStyle {
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
