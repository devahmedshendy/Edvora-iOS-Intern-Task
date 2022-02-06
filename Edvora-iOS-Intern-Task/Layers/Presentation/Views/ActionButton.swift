//
//  ActionButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

class ActionButton: UIButton {
        
    // MARK: - Subviews
    
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
        setTitle("Action", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .gray

        titleLabel?.font = .actionButtonTitleFont
        
        layer.cornerRadius = .cornerRadius
        
        contentEdgeInsets = UIEdgeInsets(
            top: 8,
            left: 35,
            bottom: 8,
            right: 35
        )
    }
    
}
