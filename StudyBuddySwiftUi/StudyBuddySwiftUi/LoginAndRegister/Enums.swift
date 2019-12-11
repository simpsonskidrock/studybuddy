//
// Created by admin on 10.12.19.
// Copyright (c) 2019 Annika Jung. All rights reserved.
//

import Foundation

enum RegisterDataValidity: String {
    case invalidEmail = "Invalid Email"
    case shortPassword = "Password too short"
    case unequalPasswords = "Passwords don't match"
    case valid = ""
}

enum RegisterError: Error {
    case unknown(message: String)
    case passwordRequirementsNotMet
    case invalidEmail
}

extension RegisterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return NSLocalizedString(message, comment: "RegisterError")
        case .passwordRequirementsNotMet:
            return NSLocalizedString("Password requirements not met", comment: "RegisterError")
        case .invalidEmail:
            return NSLocalizedString("Invalid eMail", comment: "RegisterError")
        }
    }
}
