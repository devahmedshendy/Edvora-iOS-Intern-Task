//
//  HorizontalSeparatorView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class HorizontalSeparatorView: UIView {
    
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
        backgroundColor = .separatorBackgroundColor
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}
