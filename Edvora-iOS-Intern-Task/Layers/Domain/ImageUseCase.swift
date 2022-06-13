//
//  ImageUseCase.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import Foundation

final class ImageUseCase {
    
    // MARK: - Properties
    
    private let remote: HttpRepository!
    
    // MARK: - inits
    
    init(networkDataSource: HttpRepository) {
        remote = networkDataSource
    }
    
    // MARK: - Business Logic
    
    func getImage(_ imageUrl: String,
                  onSuccess: @escaping (Data) -> Void,
                  onError: @escaping (PresentationError) -> Void) {
        remote.getImage(
            imageUrl,
            onSuccess: onSuccess,
            onError: { error in
                let pError = PresentationError(from: error)
                Logger.debug(pError.description)
                onError(pError)
            }
        )
    }
}
