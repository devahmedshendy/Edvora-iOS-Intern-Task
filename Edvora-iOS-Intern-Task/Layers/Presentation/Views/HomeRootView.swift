//
//  HomeRootView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class HomeRootView: UIView {
    
    // MARK: - Properties
    
    private var serialQueue = DispatchQueue(label: "HomeRootView")
    
    private var productList: [ProductDto] = []
    
    private var sections: [String] = []
    private var productsMap: [String : [ProductDto]] = [:]
    
    private var filtersDto: FiltersDto!
    
    private var dataSource: UICollectionViewDiffableDataSource<String, ProductDto>!
    
    // MARK: - Subviews
    
    private var activityIndicator: UIActivityIndicatorView!
    private var filtersView: FiltersBarView!
    private var filtersPopupView: FiltersPopupView!
    private var collectionView: CollectionView!
    private var noRecordFoundLabel: UILabel!
    
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
        activityIndicator = UIActivityIndicatorView()
        
        filtersView = FiltersBarView()
        filtersPopupView = FiltersPopupView()
        collectionView = CollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        
        noRecordFoundLabel = UILabel()
        
        // Add the Subviews
        addSubview(filtersView)
        addSubview(collectionView)
        addSubview(noRecordFoundLabel)
        addSubview(activityIndicator)
        
        // Setup the Subviews
        setupFiltersView()
        setupCollectionView()
        configureCollectionView()
        setupNoRecordFoundLabel()
        setupActivityIndicator()
    }
    
    func reloadWith(list: [ProductDto]) {
        productList = list
        filtersDto = FiltersDto(from: productList)
        
        refreshCollectionViewDataSoure()
        
        filtersView.isHidden = productList.isEmpty
        collectionView.isHidden = productList.isEmpty
        noRecordFoundLabel.isHidden = productList.isNotEmpty
    }
    
    func onDataLoading(_ isLoading: Bool) {
        if isLoading {
            startActivityIndicator()
        } else {
            stopActivityIndicator()
        }
    }
    
    private func startActivityIndicator() {
        filtersView.isHidden = true
        collectionView.isHidden = true
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func stopActivityIndicator() {
        filtersView.isHidden = false
        collectionView.isHidden = false
        
        activityIndicator.stopAnimating()
    }
}

// MARK: - FiltersBarViewDelegate

extension HomeRootView: FiltersBarViewDelegate {
    
    func onFiltersSelectButtonTapped() {
        addSubview(filtersPopupView)
        setupFiltersPopupView()
    }
    
    func onClearFiltersButtonTapped() {
        filtersDto.clearSelections()
        filtersPopupView.reset()
        filtersView.setClearButton(asHidden: true)
        refreshCollectionViewDataSoure()
    }
    
    private func setupFiltersPopupView() {
        filtersPopupView.delegate = self
        filtersPopupView.filtersDto = filtersDto
        
        // Constraint Configuration
        filtersPopupView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = filtersPopupView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = filtersPopupView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = filtersPopupView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = filtersPopupView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
}

// MARK: - FiltersPopupViewDelegate

extension HomeRootView: FiltersPopupViewDelegate {

    func dismissFiltersPopup() {
        filtersPopupView.removeFromSuperview()
        
        if filtersDto != filtersPopupView.filtersDto {
            filtersDto = filtersPopupView.filtersDto
            
            filtersView.setClearButton(asHidden: filtersDto.isEmpty)
            
            refreshCollectionViewDataSoure()
        }
    }
    
}

// MARK: - Subviews Configurations

extension HomeRootView {
    
    private func setupFiltersView() {
        filtersView.delegate = self
        
        // Constraint Configuration
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = filtersView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .screenLeadingPadding)
        let trailing = filtersView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .screenTrailingPadding)
        let top = filtersView.topAnchor.constraint(equalTo: self.topAnchor, constant: .screenTopPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupNoRecordFoundLabel() {
        noRecordFoundLabel.isHidden = true
        noRecordFoundLabel.text = "No Record Found!"
        noRecordFoundLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        noRecordFoundLabel.textColor = .hintColor
        
        // Constraints Configuration
        noRecordFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = noRecordFoundLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = noRecordFoundLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        // Constraints Configuration
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
}

// MARK: - Configure CollectionView

extension HomeRootView {
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(
            ProductCell.self,
            forCellWithReuseIdentifier: ProductCell.reuseIdentifier
        )
        collectionView.register(
            ProductsHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProductsHeaderView.reuseIdentifier
        )
        
        // Constraint Configuration
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = collectionView.topAnchor.constraint(equalTo: filtersView.bottomAnchor, constant: 25)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
    
    private func configureCollectionView() {
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
    }
    
    private func configureCollectionViewLayout() {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )
        )
                
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .estimated(20)
            ),
            subitem: item, count: 1
        )
                
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: .productCollectionTopInset,
                                                        leading: .productCollectionLeadingInset,
                                                        bottom: .productCollectionBottomInset,
                                                        trailing: 0)
        
        collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout(section: section),
            animated: false
        )
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, ProductDto>(collectionView: collectionView) { (collectionView, indexPath, productDto) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else { return nil }
            
            cell.vm = ImageVM(
                imageUseCase: ImageUseCase(
                    networkDataSource: NativeHttpDataSource()
                )
            )
            cell.dto = productDto
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductsHeaderView.reuseIdentifier, for: indexPath) as! ProductsHeaderView
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view.header = section
            
            return view
        }
        
        let snapshot = NSDiffableDataSourceSnapshot<String, ProductDto>()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func refreshCollectionViewDataSoure() {
        let snapshot = NSDiffableDataSourceSnapshot<String, ProductDto>()
        dataSource.apply(snapshot, animatingDifferences: false)
        
        self.startActivityIndicator()
        
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            let filteredProducts = self.filtersDto.applyTo(list: self.productList)
//            Logger.debug(filteredProducts)
            self.productsMap = self.toProductsMap(filteredProducts)
            self.sections = self.productsMap.keys.sorted()
            
//            Logger.debug(self.productsMap[self.sections[0]])
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<String, ProductDto>()
                
                snapshot.appendSections(self.sections)
                self.productsMap.keys.forEach { section in
                    snapshot.appendItems(self.productsMap[section]!, toSection: section)
                }
                
                self.dataSource.apply(snapshot, animatingDifferences: true)
                self.stopActivityIndicator()
            }
        }
    }
    
    private func toProductsMap(_ list: [ProductDto]) -> [String : [ProductDto]] {
        var productsMap: [String : [ProductDto]] = [:]
        
        for product in list {
            if productsMap[product.name] == nil {
                productsMap[product.name] = []
            }
            
            productsMap[product.name]!.append(product)
        }
        
        return productsMap
    }
}

/*
 This subclass solves a bug in iOS 14.3 for Compositional Layout
 source: https://stackoverflow.com/a/65941312/4538920
 */
public final class CollectionView: UICollectionView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard #available(iOS 14.3, *) else { return }
        
        subviews.forEach { subview in
            guard
                let scrollView = subview as? UIScrollView,
                let minY = scrollView.subviews.map(\.frame.origin.y).min(),
                let maxHeight = scrollView.subviews.map(\.frame.height).max(),
                minY > scrollView.frame.minY || maxHeight > scrollView.frame.height
            else { return }
            
            scrollView.contentInset.top = -minY
            scrollView.frame.origin.y = minY
            scrollView.frame.size.height = maxHeight
        }
    }
}
