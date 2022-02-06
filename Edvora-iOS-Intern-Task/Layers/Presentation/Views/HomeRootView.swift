//
//  HomeRootView.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import UIKit

final class HomeRootView: UIView {
    
    // MARK: - Properties
    
    private var serialQueue = DispatchQueue(label: String(describing: self), qos: .userInitiated)
    
    private var productList: [ProductDto] = []
    
    private var filteredProductSections: [String] = []
    private var filteredProductMap: [String : [ProductDto]] = [:]
    
    private var filtersDto: FiltersDto!
    
    private var dataSource: UICollectionViewDiffableDataSource<String, ProductDto>!
    
    private var isPreparingProducts: Bool = false {
        didSet {
            spinnerView.updateVisibility(isPreparingProducts, forState: .isPreparing)
        }
    }
    
    private var isApplyingFilters: Bool = false {
        didSet {
            spinnerView.updateVisibility(isApplyingFilters, forState: .isApplyingFilters)
        }
    }
    
    private var isClearingFilters: Bool = false {
        didSet {
            spinnerView.updateVisibility(isClearingFilters, forState: .isClearingFilters)
        }
    }
    
    // MARK: - Subviews
    
    private var spinnerView: StateBasedSpinnerView!
    
    private var noRecordFoundLabel: UILabel!
    
    private var filtersBarView: FiltersBarView!
    private var filtersPopupView: FiltersPopupView!
    
    private var collectionView: CollectionView!
    
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
        noRecordFoundLabel = UILabel()
        
        filtersBarView = FiltersBarView()
        filtersPopupView = FiltersPopupView()
        
        collectionView = CollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        
        // Add the Subviews
        addSubview(filtersBarView)
        addSubview(collectionView)
        addSubview(noRecordFoundLabel)
        
        spinnerView = StateBasedSpinnerView(containerView: self)
        
        // Setup the Subviews
        setupFiltersBarView()
        setupCollectionView()
        configureCollectionView()
        setupNoRecordFoundLabel()
    }
    
    // MARK: - Helpers
    
    func reloadWith(list: [ProductDto]) {
        productList = list
        filtersDto = FiltersDto(from: productList)
        
        prepareProducts(
            onStarted: { [weak self] in
                self?.isPreparingProducts = true
            },
            onCompleted: { [weak self] in
                guard let self = self else { return }
                
                self.loadDataSource()
                
                self.filtersBarView.isHidden = self.filteredProductSections.isEmpty
                self.collectionView.isHidden = self.filteredProductSections.isEmpty
                self.noRecordFoundLabel.isHidden = self.filteredProductSections.isNotEmpty
                
                self.isPreparingProducts = false
            }
        )
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
        filtersPopupView.resetFilters()
        filtersBarView.setClearButtonVisibility(isHidden: true)
        
        applyFiltersOnProductList(
            onStarted: { [weak self] in
                self?.isClearingFilters = true
            },
            onCompleted: { [weak self] in
                guard let self = self else { return }
                
                self.loadDataSource()
                
                self.collectionView.isHidden = self.filteredProductSections.isEmpty
                self.noRecordFoundLabel.isHidden = self.filteredProductSections.isNotEmpty
                
                self.isClearingFilters = false
            }
        )
    }
    
}

// MARK: - FiltersPopupViewDelegate

extension HomeRootView: FiltersPopupViewDelegate {
    
    func dismissFiltersPopup() {
        filtersPopupView.removeFromSuperview()
    }
    
    func applyFilters() {
        filtersPopupView.removeFromSuperview()
        
        if filtersDto != filtersPopupView.filtersDto {
            filtersDto = filtersPopupView.filtersDto
            
            filtersBarView.setClearButtonVisibility(isHidden: filtersDto.isEmpty)
            
            applyFiltersOnProductList(
                onStarted: { [weak self] in
                    self?.isApplyingFilters = true
                },
                onCompleted: { [weak self] in
                    guard let self = self else { return }
                    
                    self.loadDataSource()
                    
                    self.collectionView.isHidden = self.filteredProductSections.isEmpty
                    self.noRecordFoundLabel.isHidden = self.filteredProductSections.isNotEmpty
                    
                    self.isApplyingFilters = false
                }
            )
        }
    }
    
}

// MARK: - DataSource Operations

extension HomeRootView {
    
    private func prepareProducts(onStarted: () -> Void,
                                 onCompleted: @escaping () -> Void) {
        onStarted()
        
        serialQueue.async { [weak self] in
            self?._applyFiltersOnProductList()
            
            DispatchQueue.main.async(execute: onCompleted)
        }
    }
    
    private func applyFiltersOnProductList(onStarted: () -> Void,
                                           onCompleted: @escaping () -> Void) {
        onStarted()
        
        serialQueue.async { [weak self] in
            self?._applyFiltersOnProductList()
            
            DispatchQueue.main.async(execute: onCompleted)
        }
    }
    
    private func _applyFiltersOnProductList() {
        filteredProductMap = [:]
        
        let filteredProducts = filtersDto.applyTo(list: self.productList)
        
        for product in filteredProducts {
            if filteredProductMap[product.name] == nil {
                filteredProductMap[product.name] = []
            }
            
            filteredProductMap[product.name]!.append(product)
        }
        
        filteredProductSections = filteredProductMap.keys.sorted()
    }
    
}

// MARK: - Subviews Configurations

extension HomeRootView {
    
    private func setupFiltersBarView() {
        filtersBarView.isHidden = true
        
        filtersBarView.delegate = self
        
        // Constraint Configuration
        filtersBarView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = filtersBarView.leadingAnchor
            .constraint(equalTo: self.leadingAnchor, constant: .screenLeadingPadding)
        let trailing = filtersBarView.trailingAnchor
            .constraint(equalTo: self.trailingAnchor, constant: .screenTrailingPadding)
        let top = filtersBarView.topAnchor
            .constraint(equalTo: self.topAnchor, constant: .screenTopPadding)
        
        NSLayoutConstraint.activate([
            leading, trailing, top
        ])
    }
    
    private func setupNoRecordFoundLabel() {
        noRecordFoundLabel.isHidden = true
        
        noRecordFoundLabel.text = "No Record Found!"
        noRecordFoundLabel.font = .noRecordTitleFont
        noRecordFoundLabel.textColor = .hintColor
        
        // Constraints Configuration
        noRecordFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = noRecordFoundLabel.centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
        let centerY = noRecordFoundLabel.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerX, centerY
        ])
    }
    
    private func setupFiltersPopupView() {
        filtersPopupView.delegate = self
        filtersPopupView.filtersDto = filtersDto
        
        // Constraint Configuration
        filtersPopupView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = filtersPopupView.leadingAnchor
            .constraint(equalTo: self.leadingAnchor)
        let trailing = filtersPopupView.trailingAnchor
            .constraint(equalTo: self.trailingAnchor)
        let top = filtersPopupView.topAnchor
            .constraint(equalTo: self.topAnchor)
        let bottom = filtersPopupView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}

// MARK: - Configure CollectionView

extension HomeRootView {
    
    private func setupCollectionView() {
        collectionView.isHidden = true
        
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
        
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: self.leadingAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: self.trailingAnchor)
        let top = collectionView.topAnchor
            .constraint(equalTo: filtersBarView.bottomAnchor, constant: .homeCollectionViewTopPadding)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor)
        
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
                widthDimension: .productCellGroupWidthDimention,
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
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .productCollectionTopInset,
            leading: .productCollectionLeadingInset,
            bottom: .productCollectionBottomInset,
            trailing: 0
        )
        
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
        
        loadDataSourceWithEmptySnapshot()
    }
    
    private func loadDataSourceWithEmptySnapshot() {
        let snapshot = NSDiffableDataSourceSnapshot<String, ProductDto>()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func loadDataSource() {
        loadDataSourceWithEmptySnapshot()
        
        var snapshot = NSDiffableDataSourceSnapshot<String, ProductDto>()
        
        snapshot.appendSections(filteredProductSections)
        
        filteredProductMap.keys.forEach { section in
            let products = filteredProductMap[section]!
            snapshot.appendItems(products, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
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
