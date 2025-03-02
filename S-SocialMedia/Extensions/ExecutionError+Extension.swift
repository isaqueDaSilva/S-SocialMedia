//
//  ExecutionError+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/21/25.
//

import ErrorWrapper
import Foundation

extension ExecutionError {
    static let fieldsEmpty = ExecutionError(
        title: "Fields Empty",
        descrition: "To execute this action, you need to fill all fields."
    )
    
    static let unknownError = ExecutionError(
        title: "Unknown Error",
        descrition: "An unknown error occur when this action was executed. Please try again or contact us to try solve this problem."
    )
    
    static let noUser = ExecutionError(
        title: "No User Available",
        descrition: "To execute this action you need to have an user created."
    )
    
    static let noSession = ExecutionError(
        title: "No Session Available",
        descrition: "The are no session to use this aplication. Please log in the system."
    )
    
    static let noProfile = ExecutionError(
        title: "No Profile Available",
        descrition: "To execute this action you need to have a profile available."
    )
    
    static let failedToDeccode = ExecutionError(
        title: "Decode Failure Detected",
        descrition: "We're unable to process the data due to a decoding error. Please verify contact us to support you about this issue."
    )
}

extension ExecutionError: @retroactive LocalizedError {
    public var errorDescription: String? {
        self.descrition
    }
}
