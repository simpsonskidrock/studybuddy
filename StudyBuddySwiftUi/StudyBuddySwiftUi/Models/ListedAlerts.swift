//
//  ListedAlerts.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 21.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

extension Alert {
    static let alertEmptyField: Alert = Alert(title: Text("Field is required"), message: Text("You have left a field empty!"))
    
    static let alertIncorrectData: Alert = Alert(title: Text("Invalid Data"), message: Text("Please enter a valid Email and Password"))
    
    static let alertUnequalPassword: Alert = Alert(title: Text("Error"), message: Text("Confirm password and Password do not match."))
    
    static let alertTooShortPassword: Alert = Alert(title: Text("Too short password"), message: Text("the Password Field must be at least 6 characters."))
    
    static let alertSuccessResetPassword: Alert = Alert(title: Text("Reset Password"), message: Text("we have just sent you a password reset email. Please check your inbox and follow the instructions.."))
    
    static let alertMatch: Alert = Alert(title: Text("Match!"), message: Text("You have a match."))
}
