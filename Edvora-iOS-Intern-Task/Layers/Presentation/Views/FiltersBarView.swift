//
//  FiltersBarView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

protocol FiltersBarViewDelegate: AnyObject {
    func onFiltersSelectButtonTapped()
    func onClearFiltersButtonTapped()
}

final class FiltersBarView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: FiltersBarViewDelegate?
    
    // MARK: - Subviews
    
    private var selectButton: SelectButton!
    private var clearButton: UIButton!
    
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
        selectButton = SelectButton()
        clearButton = UIButton()
        
        // Add the Subviews
        addSubview(selectButton)
        addSubview(clearButton)
        
        // Setup the Subviews
        setupSelectButton()
        setupClearButton()
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        selectButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onFiltersSelectButtonTapped)
            )
        )
        
        clearButton.addTarget(
            self,
            action: #selector(onClearFiltersButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func onFiltersSelectButtonTapped() {
        delegate?.onFiltersSelectButtonTapped()
    }
    
    @objc private func onClearFiltersButtonTapped() {
        delegate?.onClearFiltersButtonTapped()
    }
    
    // MARK: - Helpers
    
    func setClearButtonVisibility(isHidden: Bool) {
        clearButton.isHidden = isHidden
    }
    
}

// MARK: - Subviews Configurations

extension FiltersBarView {
    
    private func setupSelectButton() {
        selectButton.placeholder = "Filters"
        
        // Constraint Configuration
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = selectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = selectButton.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -20)
        trailing.priority = .fittingSizeLevel
        let top = selectButton.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = selectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
    private func setupClearButton() {
        clearButton.isHidden = true
        clearButton.setTitle("Clear Filter", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.backgroundColor = .formInputBackgroundColor
        clearButton.layer.cornerRadius = .cornerRadius
        clearButton.titleLabel?.font = .regularRoboto(ofSize: 16)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
        
        // Constraint Configuration
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let trailing = clearButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        
        NSLayoutConstraint.activate([
            centerY, trailing
        ])
    }
}
