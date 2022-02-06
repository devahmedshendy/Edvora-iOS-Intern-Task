//
//  HomeVC.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit
import Combine

class HomeVC: BaseVC {
    
    // MARK: - Properties
    
    var vm: HomeVM!
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Subviews
    
    private var loadingSpinner: LoadingSpinnerView!
    private var rootView: HomeRootView!
    
    // MARK: - inits
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()
        
        rootView = HomeRootView()
        loadingSpinner = LoadingSpinnerView(containerView: rootView)
        
        view.addSubview(rootView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        
        fetchProductList()
    }

    // MARK: - ViewModel Setup
    
    private func setupViewModel() {
        vm.loadingPublisher
            .assign(to: \.isShown, on: loadingSpinner)
            .store(in: &subscriptions)
        
        vm.dataPublisher
            .sink(receiveValue: rootView.reloadWith(list:))
            .store(in: &subscriptions)
        
        vm.errorPublisher
            .sink(receiveValue: showErrorAlert(_:))
            .store(in: &subscriptions)
    }
    
    // MARK: - Helpers
    
    private func fetchProductList() {
        vm.fetchProductList()
    }
}

// MARK: - Subviews Configurations

extension HomeVC {
    
    private func setupViews() {
        setupView()
        setupNavigationBar()
        setupRootView()
    }
    
    private func setupView() {
        view.backgroundColor = .screenColor
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Edvora"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(onRefreshBarButtonTapped)
        )
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.prefersLargeTitles = true
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 0, height: 4)
        
        navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.navbarTitleColor,
            NSAttributedString.Key.shadow: shadow
        ]
        
    }
    
    @objc private func onRefreshBarButtonTapped() {
        vm.fetchProductList()
    }
    
    private func setupRootView() {

        // Constraint Configuration
        rootView.translatesAutoresizingMaskIntoConstraints = false

        let leading = rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}

// MARK: - Static Initialization

extension HomeVC {
    
    static func initialize() -> HomeVC {
        let remote = EdvoraDataSource()
        let productsUseCase = ProductsUseCase(apiDataSource: remote)
        let vm = HomeVM(productsUseCase: productsUseCase)
        
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "HomeVC") as! HomeVC
        vc.vm = vm
        
        return vc
    }
    
}
