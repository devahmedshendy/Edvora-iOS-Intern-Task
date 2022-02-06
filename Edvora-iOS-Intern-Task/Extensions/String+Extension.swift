//
//  String+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

extension String {
    func fromISOtoDate() -> Date {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds
        ]
        
        return isoDateFormatter.date(from: self)!
    }
}

extension String {
    var isNotEmpty: Bool { !isEmpty }
}
