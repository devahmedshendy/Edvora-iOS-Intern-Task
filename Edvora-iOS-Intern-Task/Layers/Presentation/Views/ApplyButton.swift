//
//  ApplyButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

class ApplyButton: ActionButton {
    
    // MARK: - Subviews
    
    // MARK: - inits
    
    override func setup() {
        super.setup()
        
        setTitle("Apply", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .applyBackgroudColor
    }
    
}
