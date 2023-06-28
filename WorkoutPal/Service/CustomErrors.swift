//
//  CustomErrors.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/30/23.
//

import Foundation

enum AuthErrors: Error {
    case noProfilePic
    case wrongPassword
    case failedSignup
    case failedSignIn
    case failedReset
    case failedUpdate
}

extension AuthErrors: LocalizedError{
    
    var errorDescription: String?{
        switch self{
        case .noProfilePic:
            return NSLocalizedString("No Profile Picture Selected", comment: "No Profile Picture Selected")
        case .wrongPassword:
            return NSLocalizedString("Wrong Password", comment: "Wrong Password")
        case .failedSignup:
            return NSLocalizedString("Failed Sign Up", comment: "Signed Failed")
        case .failedSignIn:
            return NSLocalizedString("Failed Sign In", comment: "Failed Sign In")
        case .failedReset:
            return NSLocalizedString("Reset Password Fail", comment: "Reset Password Fail")
        case .failedUpdate:
            return NSLocalizedString("Failed Update", comment: "Failed Update")
        }
   
    }
}



