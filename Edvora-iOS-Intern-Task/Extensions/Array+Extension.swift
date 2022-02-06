//
//  Array+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

extension Array where Element: Equatable {
    func doesNotContains(_ element: Element) -> Bool {
        return !contains(element)
    }
}
