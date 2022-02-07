//
//  FiltersPopupView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

protocol FiltersPopupViewDelegate: AnyObject {
    func dismissFiltersPopup()
    func applyFilters()
}

final class FiltersPopupView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: FiltersPopupViewDelegate?
    
    var filtersDto: FiltersDto! {
        didSet {
            productsSelectButton.setTitle(filtersDto.selectedProducts.joined(separator: ", "))
            stateSelectButton.setTitle(filtersDto.selectedState)
            citySelectButton.setTitle(filtersDto.selectedCity)
        }
    }
    
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
    private var applyButton: ApplyButton!
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
    
    // MARK: - Setup
    
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
        
        applyButton = ApplyButton()
        
        // Add the Subviews
        addSubview(overlayView)
        addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(headerSeparator)
        contentView.addSubview(selectButtonStack)
        contentView.addSubview(applyButton)
        
        // Setup the Subviews
        setupOverlayView()
        setupContentView()
        setupHeaderLabel()
        setupHeaderSeparator()
        setupSelectButtonStack()
        setupApplyButton()
        
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
        
        applyButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onApplyButtonTapped)
            )
        )
    }
    
    @objc private func onOverlayViewTapped() {
        guard visibleSelectView == nil else { return }
        resetFilters()
        delegate?.dismissFiltersPopup()
    }
    
    @objc private func onApplyButtonTapped() {
        delegate?.applyFilters()
    }
    
    @objc private func onProductsSelectButtonTapped() {
        let selectView = MultiSelectView()
        visibleSelectView = selectView
        
        addSubview(selectView)
        
        setupVisibleSelectView()
        
        selectView.onSelectionDone = handleSelectedProducts
        
        selectView.reloadWith(list: filtersDto.products, previousSelections: filtersDto.selectedProducts)
    }
    
    private func handleSelectedProducts(_ selectedProducts: [String]) {
        filtersDto.selectedProducts = selectedProducts
        
        productsSelectButton.setTitle(selectedProducts.joined(separator: ", "))
        
        visibleSelectView?.removeFromSuperview()
        visibleSelectView = nil
    }
    
    @objc private func onStateSelectButtonTapped() {
        let selectView = UniSelectView()
        visibleSelectView = selectView
        
        addSubview(selectView)
        
        setupVisibleSelectView()
        
        selectView.onSelectionDone = handleSelectedState
                
        selectView.reloadWith(list: states, previousSelection: filtersDto.selectedState)
    }
    
    private func handleSelectedState(_ selectedState: String) {
        filtersDto.selectedState = selectedState
        filtersDto.selectedCity = ""
        
        stateSelectButton.setTitle(selectedState)
        
        citySelectButton.setTitle("")
        citySelectButton.isEnabled = selectedState.isNotEmpty
        
        visibleSelectView?.removeFromSuperview()
        visibleSelectView = nil
    }
    
    @objc private func onCitySelectButtonTapped() {
        guard filtersDto.selectedState.isNotEmpty else { return }
        
        let selectView = UniSelectView()
        visibleSelectView = selectView
        
        addSubview(selectView)
        
        setupVisibleSelectView()
        
        selectView.onSelectionDone = handleSelectedCity
        
        selectView.reloadWith(list: cities, previousSelection: filtersDto.selectedCity)
    }
    
    private func handleSelectedCity(_ selectedCity: String) {
        filtersDto.selectedCity = selectedCity
        
        citySelectButton.setTitle(selectedCity)
        
        visibleSelectView?.removeFromSuperview()
        visibleSelectView = nil
    }
    
    // MARK: - Helpers
    
    func resetFilters() {
        filtersDto.clearSelections()
        productsSelectButton.reset()
        stateSelectButton.reset()
        citySelectButton.reset()
        citySelectButton.isEnabled = false
    }
}

// MARK: - Subviews Configurations

extension FiltersPopupView {
    
    private func setupOverlayView() {
        overlayView.backgroundColor = .overlayColor
        overlayView.isUserInteractionEnabled = true
        
        // Constraint Configuration
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = overlayView.leadingAnchor
            .constraint(equalTo: self.leadingAnchor)
        let trailing = overlayView.trailingAnchor
            .constraint(equalTo: self.trailingAnchor)
        let top = overlayView.topAnchor
            .constraint(equalTo: self.topAnchor)
        let bottom = overlayView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
    private func setupContentView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = .filterPopupCornerRadius
        contentView.backgroundColor = .popupBackgroundColor
        
        // Constraint Configuration
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = contentView.centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
        let centerY = contentView.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = "Filters"
        headerLabel.numberOfLines = 1
        headerLabel.textAlignment = .left
        headerLabel.font = .filtersPopupHeaderFont
        headerLabel.textColor = .filtersPopupHeaderColor
        
        // Constraint Configuration
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = headerLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor,
                        constant: .filtersPopupContentLeadingPadding)
        let trailing = headerLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor,
                        constant: .filtersPopupContentTrailingPadding)
        let top = headerLabel.topAnchor
            .constraint(equalTo: contentView.topAnchor,
                        constant: .filtersPopupContentTopPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }

    private func setupHeaderSeparator() {
        
        // Constraint Configuration
        headerSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = headerSeparator.leadingAnchor
            .constraint(equalTo: headerLabel.leadingAnchor)
        let trailing = headerSeparator.trailingAnchor
            .constraint(equalTo: headerLabel.trailingAnchor)
        let top = headerSeparator.topAnchor
            .constraint(equalTo: headerLabel.bottomAnchor,
                        constant: .filtersPopupHeaderSeparatorTopPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupSelectButtonStack() {
        selectButtonStack.axis = .vertical
        selectButtonStack.alignment = .fill
        selectButtonStack.distribution = .fill
        selectButtonStack.spacing = .filtersPopupButtonStackSpacing
        
        productsSelectButton.placeholder = "Products"
        stateSelectButton.placeholder = "State"
        citySelectButton.placeholder = "City"
        citySelectButton.isEnabled = false
        
        // Constraint Configuration
        selectButtonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = selectButtonStack.leadingAnchor
            .constraint(equalTo: headerLabel.leadingAnchor)
        let trailing = selectButtonStack.trailingAnchor
            .constraint(equalTo: headerLabel.trailingAnchor)
        let top = selectButtonStack.topAnchor
            .constraint(equalTo: headerSeparator.bottomAnchor,
                        constant: .filtersPopupButtonStackTopPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupApplyButton() {
        
        // Constraint Configuration
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = applyButton.centerXAnchor
            .constraint(equalTo: headerLabel.centerXAnchor)
        let top = applyButton.topAnchor
            .constraint(equalTo: selectButtonStack.bottomAnchor,
                        constant: .filtersPopupApplyButtonBottomPadding)
        let bottom = applyButton.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor,
                        constant: .filtersPopupContentBottomPadding)
        
        NSLayoutConstraint.activate([
            centerX, top, bottom
        ])
    }
    
    private func setupVisibleSelectView() {
        
        // Constraint Configuration
        visibleSelectView!.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = visibleSelectView!.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor,
                        constant: .filtersPopupSelectViewLeadingPadding)
        let trailing = visibleSelectView!.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor,
                        constant: .filtersPopupSelectViewTrailingPadding)
        let top = visibleSelectView!.topAnchor
            .constraint(equalTo: contentView.topAnchor,
                        constant: .filtersPopupSelectViewTopPadding)
        let bottom = visibleSelectView!.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor,
                        constant: .filtersPopupSelectViewBottomPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}
