//
// Created by admin on 10.12.19.
// Copyright (c) 2019 Annika Jung. All rights reserved.
//

import Foundation


enum SignUpReturnCode: Equatable {
    case SUCCESS
    case ERROR(message: String)
    case UNKNOWN
    case INVALID_DATA
}

enum RegisterDataValidity: String {
    case invalidEmail = "Invalid Email"
    case shortPassword = "Password too short"
    case unequalPasswords = "Passwords don't match"
    case valid = ""
}