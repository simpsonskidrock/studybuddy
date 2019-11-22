//
//  ListedAlerts.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 21.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

extension Alert {
    static let alertEmptyField: Alert = Alert(title: Text("Field is required"), message: Text("You have left a field empty!"), dismissButton: .default(Text("OK")))
    
    static let alertIncorrectData: Alert = Alert(title: Text("Invalid Data"), message: Text("Please enter a valid Email and Password"), dismissButton: .default(Text("OK")))
    
    static let alertUnequalPassword: Alert = Alert(title: Text("Error"), message: Text("Confimation of password is different to new password"), dismissButton: .default(Text("OK")))
    
    static let alertTooShortPassword: Alert = Alert(title: Text("Too short password"), message: Text("Password needs to have minimum 6 characters."), dismissButton: .default(Text("OK")))
}
