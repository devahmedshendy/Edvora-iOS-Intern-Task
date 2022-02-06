//
//  ClearButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class ClearButton: TextButton {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        setTitle("Clear", for: .normal)
        setTitleColor(.hintColor, for: .normal)
    }
    
}
