//
//  ProductsUseCase.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

final class ProductsUseCase {
    
    // MARK: - Properties
    
    private let api: ApiRespository!
    
    // MARK: - inits
    
    init(apiDataSource: ApiRespository) {
        api = apiDataSource
    }
    
    // MARK: - Business Logic
    
    func getProductList(onSuccess: @escaping ([ProductDto]) -> Void,
                        onError: @escaping (PresentationError) -> Void) {
        api.getProductList(
            onSuccess: { modelList in
                onSuccess(modelList.map(ProductDto.init(from:)))
            },
            onError: { error in
                let pError = PresentationError(from: error)
                Logger.debug(pError.description)
                onError(pError)
            }
        )
    }
}
