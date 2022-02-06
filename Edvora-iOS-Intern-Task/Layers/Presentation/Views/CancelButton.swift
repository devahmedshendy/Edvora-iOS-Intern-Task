//
//  ClearButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

class ClearButton: TextButton {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        setTitle("Clear", for: .normal)
        setTitleColor(.doneColor, for: .normal)
    }
    
}
