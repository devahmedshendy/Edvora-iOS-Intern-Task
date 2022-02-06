//
//  HomeVM.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation
import Combine

final class HomeVM {
    
    // MARK: - Publishers
    
    let loadingPublisher = PassthroughSubject<Bool, Never>()
    let dataPublisher = PassthroughSubject<[ProductDto], Never>()
    let errorPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - Properties
    
    private var productsUseCase: ProductsUseCase
    
    // MARK: - inits
    
    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
    // MARK: - Presentation Logic
    
    func fetchProductList() {
        loadingPublisher.send(true)
        
        productsUseCase
            .getProductList(
                onSuccess: handleOnSuccess(list:),
                onError: handleOnError(error:)
            )
    }
    
    private func handleOnSuccess(list: [ProductDto]) {
        loadingPublisher.send(false)
        dataPublisher.send(list)
    }
    
    private func handleOnError(error: PresentationError) {
        loadingPublisher.send(false)
        errorPublisher.send(error.message)
    }
    
}
