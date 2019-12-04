//
//  RegisterError.swift
//  StudyBuddySwiftUi
//
//  Created by admin on 04.12.19.
//  Copyright © 2019 Annika Jung. All rights reserved.
//

import Foundation


enum RegisterError: Error {
    case unknown(message: String)
    case passwordRequirementsNotMet
    case invalidEmail
}
