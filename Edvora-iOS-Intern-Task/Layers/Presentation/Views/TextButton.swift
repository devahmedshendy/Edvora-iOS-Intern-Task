//
//  TextButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

class TextButton: UIButton {
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        backgroundColor = .clear
    }
    
}
