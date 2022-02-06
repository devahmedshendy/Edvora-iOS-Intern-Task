//
//  SelectViewCell.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

class SelectViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: SelectViewCell.self)
    
    // MARK: - inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        textLabel?.font = .selectViewCellTextFont
    }
    
}
