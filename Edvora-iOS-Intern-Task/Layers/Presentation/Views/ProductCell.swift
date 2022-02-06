//
//  ProductCell.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit
import Combine

final class ProductCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ProductCell.self)
    
    // MARK: - Properties
    
    var vm: ImageVM! {
        didSet {
            setupViewModel()
        }
    }
    
    private var subscription: AnyCancellable?
    
    private func setupViewModel() {
        subscription = vm.dataPublisher
            .sink { [weak self] imageData in
                self?.imageView.image = UIImage(data: imageData)
            }
        
    }
    
    var dto: ProductDto? {
        didSet {
            guard let dto = dto else { return }
            
            vm.fetchImage(dto.imageUrl)

            productNameLabel.text = dto.name
            brandNameLabel.text = dto.brand
            priceLabel.text = dto.price
            dateLabel.text = dto.formattedDate
            locationLabel.text = dto.location
            descriptionLabel.text = dto._description
        }
    }
    
    // MARK: - Subviews
    
    private var imageView: UIImageView!
    private var productNameLabel: UILabel!
    private var brandNameLabel: UILabel!
    private var priceLabel: UILabel!
    private var dateLabel: UILabel!
    private var locationLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - LifeCycle
    
    override func prepareForReuse() {
        imageView.image = UIImage()
        subscription?.cancel()
        subscription = nil
    }
    
    // MARK: - Setup
    
    func setup() {
        // Create the Subviews
        imageView = UIImageView()
        productNameLabel = UILabel()
        brandNameLabel = UILabel()
        priceLabel = UILabel()
        dateLabel = UILabel()
        locationLabel = UILabel()
        descriptionLabel = UILabel()
        
        // Add the Subviews
        addSubview(imageView)
        addSubview(productNameLabel)
        addSubview(brandNameLabel)
        addSubview(priceLabel)
        addSubview(dateLabel)
        addSubview(locationLabel)
        addSubview(descriptionLabel)
        
        // Setup the Subviews
        setupSelf()
        setupProductImageView()
        setupProductNameLabel()
        setupBrandNameLabel()
        setupPriceLabel()
        setupDateLabel()
        setupLocationLabel()
        setupDescriptionLabel()
    }
    
}

// MARK: - Subviews Configurations

extension ProductCell {
    
    private func setupSelf() {
        backgroundColor = .black
        layer.cornerRadius = .cornerRadius
    }
    
    private func setupProductImageView() {
        imageView.clipsToBounds = true
        imageView.backgroundColor = .navbarTitleColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .cornerRadius
        
        // Constraint Configuration
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .productCellLeadingPadding)
        let top = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: .productCellTopPadding)
        let width = imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3)
        let height = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        
        NSLayoutConstraint.activate([
            leading, top,
            width, height
        ])
    }
    
    private func setupProductNameLabel() {
        productNameLabel.text = "Product Name"
        productNameLabel.numberOfLines = 1
        productNameLabel.textColor = .productCellPrimaryColor
        productNameLabel.adjustsFontForContentSizeCategory = true
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        // Constraint Configuration
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = productNameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15)
        let trailing = productNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .productCellTrailingPadding)
        let top = productNameLabel.topAnchor.constraint(equalTo: imageView.topAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupBrandNameLabel() {
        brandNameLabel.text = "Brand Name"
        brandNameLabel.numberOfLines = 1
        brandNameLabel.textColor = .productCellSecondaryColor
        brandNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // Constraint Configuration
        brandNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = brandNameLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor)
        let trailing = brandNameLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor)
        let top = brandNameLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupPriceLabel() {
        priceLabel.text = "$ 29.99"
        priceLabel.numberOfLines = 1
        priceLabel.textColor = .productCellPrimaryColor
        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // Constraint Configuration
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = priceLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor)
        let trailing = priceLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor)
        let top = priceLabel.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.text = "Date: 10-12-2021"
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .productCellSecondaryColor
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // Constraint Configuration
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
                
        let leading = dateLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        let trailing = dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .productCellTrailingPadding)
        let top = dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupLocationLabel() {
        locationLabel.text = "Location: Cairo, Egypt"
        locationLabel.numberOfLines = 1
        locationLabel.textColor = .productCellSecondaryColor
        locationLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // Constraint Configuration
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
                
        let leading = locationLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        let trailing = locationLabel.trailingAnchor.constraint(equalTo: productNameLabel.trailingAnchor)
        let top = locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = "Date: 10-12-2021"
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .productCellSecondaryColor
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // Constraint Configuration
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                
        let leading = descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        let trailing = descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .productCellTrailingPadding)
        let top = descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10)
        top.priority = .fittingSizeLevel
        let bottom = descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .productCellBottomPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}
