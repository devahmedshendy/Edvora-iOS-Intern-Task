//
//  SpinnerView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import UIKit

class SpinnerView: UIView {
    
    // MARK: - Properties
    
    var title: String = "Spinning..." {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isShown: Bool = false {
        didSet {
            isHidden = isShown == false
            
            if isShown {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private var containerView: UIView
    
    // MARK: - Subviews
    
    private var overlayView: UIView!
    private var titleLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    private var wrapperView: UIView!
    
    // MARK: - inits
    
    @available(*, unavailable)
    init() {
        fatalError("Initializing this view without containerView is not supported.")
    }
    
    init(containerView: UIView) {
        self.containerView = containerView
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("Initializing this view without containerView is not supported.")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Initializing this view without containerView is not supported.")
    }
    
    // MARK: - Setup
    
    func setup() {
        // Create the Subviews
        overlayView = UIView()
        titleLabel = UILabel()
        activityIndicator = UIActivityIndicatorView()
        wrapperView = UIView()
        
        // Add the Subviews
        containerView.addSubview(self)
        addSubview(overlayView)
        addSubview(wrapperView)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(activityIndicator)
        
        // Setup the Subviews
        setupSelf()
        setupOverlayView()
        setupWrapperView()
        setupTitleLabel()
        setupActivityIndicator()
    }
    
}

// MARK: - Subviews Configurations

extension SpinnerView {
    
    private func setupSelf() {
        isHidden = isShown == false
        
        // Constraint Configuration
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = self.leadingAnchor
            .constraint(equalTo: containerView.leadingAnchor)
        let trailing = self.trailingAnchor
            .constraint(equalTo: containerView.trailingAnchor)
        let top = self.topAnchor
            .constraint(equalTo: containerView.topAnchor)
        let bottom = self.bottomAnchor
            .constraint(equalTo: containerView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
    private func setupOverlayView() {
        overlayView.isUserInteractionEnabled = true
        overlayView.backgroundColor = .overlayColor
        
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
    
    private func setupWrapperView() {
        wrapperView.clipsToBounds = true
        wrapperView.backgroundColor = .spinnerBackgroundColor
        wrapperView.layer.cornerRadius = .spinnerViewCornerRadius

        // Constraint Configuration
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = wrapperView.centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
        let centerY = wrapperView.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator.transform = CGAffineTransform(scaleX: .spinnerSide, y: .spinnerSide)
        activityIndicator.tintColor = .spinnerForegroundColor
        
        // Constraint Configuration
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = activityIndicator.leadingAnchor
            .constraint(equalTo: wrapperView.leadingAnchor,
                        constant: .spinnerViewLeadingPadding)
        let top = activityIndicator.topAnchor
            .constraint(equalTo: wrapperView.topAnchor,
                        constant: .spinnerViewTopPadding)
        let bottom = activityIndicator.bottomAnchor
            .constraint(equalTo: wrapperView.bottomAnchor,
                        constant: .spinnerViewBottomPadding)
        
        NSLayoutConstraint.activate([
            leading, top, bottom
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .spinnerForegroundColor
        titleLabel.font = .spinnerTitleFont
        
        // Constraint Configuration
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: activityIndicator.trailingAnchor,
                        constant: .spinnerViewContentSpacing)
        let trailing = titleLabel.trailingAnchor
            .constraint(equalTo: wrapperView.trailingAnchor,
                        constant: .spinnerViewTrailingPadding)
        let top = titleLabel.topAnchor
            .constraint(equalTo: wrapperView.topAnchor,
                        constant: .spinnerViewTopPadding)
        let bottom = titleLabel.bottomAnchor
            .constraint(equalTo: wrapperView.bottomAnchor,
                        constant: .spinnerViewBottomPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
}
