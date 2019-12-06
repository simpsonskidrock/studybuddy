//
//  ListedAlerts.swift
//  StudyBuddySwiftUi
//
//  Created by Annika Jung on 21.11.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import SwiftUI

extension Alert {
    //TODO refactor and remove alert from name. it's already in the Alert extension no need to have Alert twice
    
    static let wrongLogin: Alert = Alert(title: Text("Invalid Data"), message: Text("Email and/or password are incorrect."))
    
    static let emptyField: Alert = Alert(title: Text("Field is required"), message: Text("You have left a field empty!"))
    
    static let incorrectData: Alert = Alert(title: Text("Invalid Data"), message: Text("Please enter a valid Email and Password"))
    
    static let unequalPassword: Alert = Alert(title: Text("Error"), message: Text("Confirm password and Password do not match."))
    
    static let tooShortPassword: Alert = Alert(title: Text("Too short password"), message: Text("The Password must be at least 6 characters long."))
    
    static let successResetPassword: Alert = Alert(title: Text("Reset Password"), message: Text("we have just sent you a password reset email. Please check your inbox and follow the instructions.."))
    
    static let match: Alert = Alert(title: Text("Match!"), message: Text("You have a match."))
}
