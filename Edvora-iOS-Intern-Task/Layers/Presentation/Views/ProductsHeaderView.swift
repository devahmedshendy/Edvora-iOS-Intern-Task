//
//  ProductsHeaderView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class ProductsHeaderView: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ProductsHeaderView.self)
    
    // MARK: - Properties
    
    var header: String = "Product Name" {
        didSet {
            headerLabel.text = header
        }
    }
    
    // MARK: - Subviews
    
    private var headerLabel: UILabel!
    private var separatorView: HorizontalSeparatorView!
    
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
        // Create the Subviews
        headerLabel = UILabel()
        separatorView = HorizontalSeparatorView()
        
        // Add the Subviews
        addSubview(headerLabel)
        addSubview(separatorView)
        
        // Setup the Subviews
        setupHeaderLabel()
        setupSeparatorView()
    }
    
    // MARK: - Subviews Configurations
    
    private func setupHeaderLabel() {
        headerLabel.text = header
        headerLabel.numberOfLines = 1
        headerLabel.textColor = .white
        headerLabel.textAlignment = .left
        headerLabel.font = .productsHeaderFont
        headerLabel.adjustsFontForContentSizeCategory = true
        
        // Constraint Configuration
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .screenTrailingPadding)
        let top = headerLabel.topAnchor.constraint(equalTo: self.topAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupSeparatorView() {
        
        // Constraint Configuration
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = separatorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10)
        let bottom = separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
}
