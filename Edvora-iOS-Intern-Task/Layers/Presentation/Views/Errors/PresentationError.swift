//
//  PresentationError.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

struct PresentationError: Error, CustomStringConvertible {
    var message: String
    var description: String
    
    init(from error: Error) {
        switch error {
        case is URLError:
            message = "Failed to communicate with server"
            
        case is DecodingError:
            message = "Failed to parse data from server"
            
        default:
            message = "Something wrong happened"
        }
        
        description = (error as NSError).debugDescription
    }
    
}
