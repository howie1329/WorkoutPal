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
}

extension AuthErrors: LocalizedError{
    
    var errorDescription: String?{
        switch self{
        case .noProfilePic:
            return NSLocalizedString("No Profile Picture Selected", comment: "No Profile Picture Selected")
        case .wrongPassword:
            return NSLocalizedString("Wrong Password", comment: "Wrong Password") 
        }
    }
}
