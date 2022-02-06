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
    
    private var filtersSelectButton: SelectButton!
    private var clearFiltersButton: UIButton!
    
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
        filtersSelectButton = SelectButton()
        clearFiltersButton = UIButton()
        
        // Add the Subviews
        addSubview(filtersSelectButton)
        addSubview(clearFiltersButton)
        
        // Setup the Subviews
        setupFiltersSelectButton()
        setupClearFiltersButton()
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        filtersSelectButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onFiltersSelectButtonTapped)
            )
        )
        
        clearFiltersButton.addTarget(
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
        clearFiltersButton.isHidden = isHidden
    }
    
}

// MARK: - Subviews Configurations

extension FiltersBarView {
    
    private func setupFiltersSelectButton() {
        filtersSelectButton.placeholder = "Filters"
        
        // Constraint Configuration
        filtersSelectButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = filtersSelectButton.leadingAnchor
            .constraint(equalTo: self.leadingAnchor)
        let top = filtersSelectButton.topAnchor
            .constraint(equalTo: self.topAnchor)
        let bottom = filtersSelectButton.bottomAnchor
            .constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, top, bottom
        ])
    }
    
    private func setupClearFiltersButton() {
        clearFiltersButton.isHidden = true
        clearFiltersButton.setTitle("Clear Filter", for: .normal)
        clearFiltersButton.setTitleColor(.white, for: .normal)
        clearFiltersButton.titleLabel?.font = .filtersBarClearButtonFont
        
        clearFiltersButton.contentEdgeInsets = UIEdgeInsets(
            top: 4,
            left: 5,
            bottom: 4,
            right: 5
        )
        
        // Constraint Configuration
        clearFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = clearFiltersButton.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        let trailing = clearFiltersButton.leadingAnchor
            .constraint(equalTo: filtersSelectButton.trailingAnchor,
                        constant: .clearFiltersButtonLeadingPadding)
        
        NSLayoutConstraint.activate([
            centerY, trailing
        ])
    }
}
