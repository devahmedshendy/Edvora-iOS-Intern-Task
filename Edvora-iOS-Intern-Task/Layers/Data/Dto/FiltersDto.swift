//
//  FiltersDto.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

struct FiltersDto {
    
    // MARK: - Properties
    
    private(set) var products: [String] = []
    private(set) var states: [String] = []
    private(set) var stateCitiesMap: [String : [String]] = [:]
    
    var selectedProducts: [String] = []
    var selectedState: String = ""
    var selectedCity: String = ""
    
    // MARK: - Computed Properties
    
    var isEmpty: Bool {
        selectedProducts.isEmpty
            && selectedState.isEmpty
            && selectedCity.isEmpty
    }
    
    // MARK: - Helpers
    
    mutating func clearSelections() {
        selectedProducts = []
        selectedState = ""
        selectedCity = ""
    }
    
    func applyTo(list: [ProductDto]) -> [ProductDto] {
        guard isEmpty == false else { return list }
        
        return list.filter { product in
            isSelectedProduct(product)
                && isSelectedState(product)
                && isSelectedCity(product)
        }
    }
    
    private func isSelectedProduct(_ product: ProductDto) -> Bool {
        guard selectedProducts.isNotEmpty else { return true }
        
        return selectedProducts.contains(product.name)
    }
    
    private func isSelectedState(_ product: ProductDto) -> Bool {
        guard selectedState.isNotEmpty else { return true }
        
        return product.state == selectedState
    }
    
    private func isSelectedCity(_ product: ProductDto) -> Bool {
        guard selectedCity.isNotEmpty else { return true }
        
        return product.city == selectedCity
    }
    
}

// MARK: - inits

extension FiltersDto {
    init(from productList: [ProductDto]) {
        var productSet: Set<String> = []
        var stateSet: Set<String> = []
        var stateCitiesMapSet: [String : Set<String>] = [:]
        
        for product in productList {
            productSet.insert(product.name)
            stateSet.insert(product.state)
            
            if stateCitiesMapSet[product.state] == nil {
                stateCitiesMapSet[product.state] = []
            }
            
            stateCitiesMapSet[product.state]!.insert(product.city)
        }
        
        products = productSet.sorted()
        states = stateSet.sorted()
        stateCitiesMap = stateCitiesMapSet.mapValues { $0.sorted() }
    }
}

// MARK: - Equatable

extension FiltersDto: Equatable {
    
    static func ==(lhs: FiltersDto, rhs: FiltersDto) -> Bool {
        lhs.selectedState == rhs.selectedState
            && lhs.selectedCity == rhs.selectedCity
            && lhs.selectedProducts == rhs.selectedProducts
    }
    
}
