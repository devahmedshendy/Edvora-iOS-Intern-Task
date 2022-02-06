//
//  FiltersPopupView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

protocol FiltersPopupViewDelegate: AnyObject {
    func dismissFiltersPopup()
}

final class FiltersPopupView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: FiltersPopupViewDelegate?
    
    var filtersDto: FiltersDto!
    
    private var products: [String] {
        filtersDto.products
    }
    
    private var states: [String] {
        filtersDto.states
    }
    
    private var cities: [String] {
        filtersDto.stateCitiesMap[filtersDto.selectedState] ?? []
    }
    
    // MARK: - Subviews
    
    private var overlayView: UIView!
    
    private var headerLabel: UILabel!
    private var headerSeparator: HorizontalSeparatorView!
    
    private var productsSelectButton: SelectButton!
    private var stateSelectButton: SelectButton!
    private var citySelectButton: SelectButton!
    
    private var selectButtonStack: UIStackView!
    
    private var visibleSelectView: UIView?
    
    private var contentView: UIView!
    
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
        overlayView = UIView()
        contentView = UIView()
        headerLabel = UILabel()
        headerSeparator = HorizontalSeparatorView()
        
        productsSelectButton = SelectButton()
        stateSelectButton = SelectButton()
        citySelectButton = SelectButton()
        
        selectButtonStack = UIStackView(
            arrangedSubviews: [
                productsSelectButton,
                stateSelectButton,
                citySelectButton
            ]
        )
        
        // Add the Subviews
        addSubview(overlayView)
        addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(headerSeparator)
        contentView.addSubview(selectButtonStack)
        
        // Setup the Subviews
        setupOverlayView()
        setupContentView()
        setupHeaderLabel()
        setupHeaderSeparator()
        setupSelectButtonStack()
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        overlayView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onOverlayViewTapped)
            )
        )
        
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onContentViewTapped)
            )
        )
        
        productsSelectButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onProductsSelectButtonTapped)
            )
        )
        
        stateSelectButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onStateSelectButtonTapped)
            )
        )
        
        citySelectButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onCitySelectButtonTapped)
            )
        )
    }
    
    @objc private func onOverlayViewTapped() {
        guard visibleSelectView == nil else { return }
        delegate?.dismissFiltersPopup()
    }
    
    @objc private func onContentViewTapped() {
        
    }
    
    @objc private func onProductsSelectButtonTapped() {
        Logger.info("onProductCategoriesSelected")
        guard visibleSelectView == nil else { return }
        
        let selectView = MultiSelectView()
        visibleSelectView = selectView
        
        addSubview(selectView)
        
        setupSelectView(selectView, accordingTo: productsSelectButton)
        
        selectView.onSelectionDone = { [weak self] selectedProducts in
            self?.filtersDto.selectedProducts = selectedProducts
            
            self?.productsSelectButton.setTitle(selectedProducts.joined(separator: ", "))
            
            self?.visibleSelectView?.removeFromSuperview()
            self?.visibleSelectView = nil
        }
        
        selectView.reloadWith(list: filtersDto.products, previousSelections: filtersDto.selectedProducts)
    }
    
    private func setupSelectView(_ selectView: UIView, accordingTo selectButton: UIView) {
        
        // Constraint Configuration
        selectView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = selectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -25)
        let trailing = selectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 25)
        let top = selectView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -25)
        let bottom = selectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 25)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
            
        ])
    }
    
    @objc private func onStateSelectButtonTapped() {
        guard visibleSelectView == nil else { return }
        
        let selectView = UniSelectView()
        visibleSelectView = selectView
        
        addSubview(selectView)
        
        setupSelectView(selectView, accordingTo: stateSelectButton)
        
        selectView.onSelectionDone = { [weak self] selectedState in
            self?.filtersDto.selectedState = selectedState
            self?.filtersDto.selectedCity = ""
            
            self?.stateSelectButton.setTitle(selectedState)
            
            self?.citySelectButton.setTitle("")
            self?.citySelectButton.isEnabled = selectedState.isNotEmpty
            
            self?.visibleSelectView?.removeFromSuperview()
            self?.visibleSelectView = nil
        }
                
        selectView.reloadWith(list: states, previousSelection: filtersDto.selectedState)
    }
    
    @objc private func onCitySelectButtonTapped() {
        Logger.info("onCitySelectButtonTapped")
        
        guard visibleSelectView == nil,
              filtersDto.selectedState.isNotEmpty else { return }
        
        let selectView = UniSelectView()
        visibleSelectView = selectView
        
        addSubview(selectView)
        
        setupSelectView(selectView, accordingTo: citySelectButton)
        
        selectView.onSelectionDone = { [weak self] selectedCity in
            self?.filtersDto.selectedCity = selectedCity
            
            self?.citySelectButton.setTitle(selectedCity)
            
            self?.visibleSelectView?.removeFromSuperview()
            self?.visibleSelectView = nil
        }
        
        selectView.reloadWith(list: cities, previousSelection: filtersDto.selectedCity)
    }
    
    // MARK: - Helpers
    
    func reset() {
        filtersDto.clearSelections()
        productsSelectButton.reset()
        stateSelectButton.reset()
        citySelectButton.reset()
    }
}

// MARK: - Subviews Configurations

extension FiltersPopupView {
    
    private func setupOverlayView() {
        overlayView.backgroundColor = .overlayColor
        
        // Constraint Configuration
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = overlayView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
    private func setupContentView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = .filterViewCornerRadius
        contentView.backgroundColor = .filtersBackgroundColor
        
        // Constraint Configuration
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = "Filters"
        headerLabel.numberOfLines = 1
        headerLabel.textAlignment = .left
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        headerLabel.textColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
        
        // Constraint Configuration
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .filtersViewContentLeadingPadding)
        let trailing = headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .filtersViewContentTrailingPadding)
        let top = headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .filtersViewContentTopPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }

    private func setupHeaderSeparator() {
        headerSeparator.backgroundColor = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1)
        
        // Constraint Configuration
        headerSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = headerSeparator.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor)
        let trailing = headerSeparator.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
        let top = headerSeparator.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10)
        let height = headerSeparator.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([
            leading, trailing, top,
            height
        ])
    }
    
    private func setupSelectButtonStack() {
        selectButtonStack.axis = .vertical
        selectButtonStack.alignment = .fill
        selectButtonStack.distribution = .fill
        selectButtonStack.spacing = 12
        
        productsSelectButton.placeholder = "Products"
        stateSelectButton.placeholder = "State"
        citySelectButton.placeholder = "City"
        citySelectButton.isEnabled = false
        
        // Constraint Configuration
        selectButtonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = selectButtonStack.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor)
        let trailing = selectButtonStack.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
        let top = selectButtonStack.topAnchor.constraint(equalTo: headerSeparator.bottomAnchor, constant: 35)
        let bottom = selectButtonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .filtersViewContentBottomPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}
