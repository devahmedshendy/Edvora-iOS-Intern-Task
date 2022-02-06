//
//  DoneButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class DoneButton: TextButton {
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        setTitle("Done", for: .normal)
        setTitleColor(.doneColor, for: .normal)
    }
    
}
