//
//  UIDevice+Extension.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

extension UIDevice {
    static var iPad: Bool {
        current.userInterfaceIdiom == .pad
    }
}
