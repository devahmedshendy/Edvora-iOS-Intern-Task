//
//  NativeHttpRepository.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import Foundation
import Combine

final class NativeHttpRepository: HttpRepository {
    
    // MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()
    
    private var getImageSub: AnyCancellable?
    
    // MARK: - inits
    
    deinit {
        releaseSubscriptions()
    }
    
    func getImage(_ imageUrl: String,
                  onSuccess: @escaping (Data) -> Void,
                  onError: @escaping (Error) -> Void) {
        releaseSubscriptions()
        
        let url = URL(string: imageUrl)!
        
        getImageSub = defaultSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        onError(error)
                    }
                },
                receiveValue: { imageData in
                    onSuccess(imageData)
                }
            )
        
    }
 
    // MARK: - Helpers
    
    private func releaseSubscriptions() {
        getImageSub?.cancel()
        getImageSub = nil
    }
}
