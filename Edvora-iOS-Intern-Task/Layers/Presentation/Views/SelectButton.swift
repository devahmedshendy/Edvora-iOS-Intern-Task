//
//  SelectButton.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class SelectButton: UIView {
    
    // MARK: - Properties
    
    var placeholder: String = "Select" {
        didSet {
            titleLabel.text = placeholder
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            self.alpha = isEnabled ? 1 : 0.45
        }
    }
    
    // MARK: - Subviews
    
    private var titleLabel: UILabel!
    private var iconView: UIImageView!
    
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
        titleLabel = UILabel()
        iconView = UIImageView()
        
        // Add the Subviews
        addSubview(titleLabel)
        addSubview(iconView)
        
        // Setup the Subviews
        setupSelf()
        setupTitleLabel()
        setupIconView()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title.isEmpty ? placeholder : title
    }
    
    func reset() {
        titleLabel.text = placeholder
    }
}

// MARK: - Subviews Configurations

extension SelectButton {
    
    private func setupSelf() {
        clipsToBounds = true
        backgroundColor = .selectButtonBackgroundColor
        layer.cornerRadius = .selectButtonCornerRadius
        
        let width = widthAnchor.constraint(
            equalToConstant: UIDevice.iPad
                ? UIScreen.main.bounds.width * 0.40
                : UIScreen.main.bounds.width * 0.50
        )

        NSLayoutConstraint.activate([
            width
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = placeholder
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = .selectButtonTitleFont
        
        // Constraint Configuration
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: self.leadingAnchor,
                        constant: .selectButtonLeadingPadding)
        let trailing = titleLabel.trailingAnchor
            .constraint(equalTo: iconView.leadingAnchor,
                        constant: .selectButtonTitleTrailingPadding)
        let top = titleLabel.topAnchor
            .constraint(equalTo: self.topAnchor,
                        constant: .selectButtonTopPadding)
        let bottom = titleLabel.bottomAnchor
            .constraint(equalTo: self.bottomAnchor,
                        constant: .selectButtonBottomPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
    private func setupIconView() {
        iconView.image = UIImage(named: "downTriangle")
        
        // Constraint Configuration
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let centerY = iconView.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        let trailing = iconView.trailingAnchor
            .constraint(equalTo: self.trailingAnchor,
                        constant: .selectButtonTrailingPadding)
        
        NSLayoutConstraint.activate([
            centerY, trailing
        ])
    }
    
}
