//
//  ImageVM.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import Foundation
import Combine

final class ImageVM {
    
    // MARK: - Publishers
    
    let loadingPublisher = PassthroughSubject<Bool, Never>()
    let dataPublisher = PassthroughSubject<Data, Never>()
    
    // MARK: - Properties
    
    private var imageUseCase: ImageUseCase
    
    // MARK: - inits
    
    init(imageUseCase: ImageUseCase) {
        self.imageUseCase = imageUseCase
    }
    
    // MARK: - Presentation Logic
    
    func fetchImage(_ imageUrl: String) {
        imageUseCase
            .getImage(
                imageUrl,
                onSuccess: dataPublisher.send(_:),
                onError: { _ in }
            )
    }
    
}
