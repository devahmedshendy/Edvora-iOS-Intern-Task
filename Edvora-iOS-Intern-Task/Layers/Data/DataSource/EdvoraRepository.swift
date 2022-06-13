//
//  EdvoraRepository.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation
import Combine

final class EdvoraRepository: ApiRespository {
    
    // MARK: - Properties
    
    private let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration)
    }()

    private var jsonDecoder = JSONDecoder()
    private var getProductListSub: AnyCancellable?
    
    // MARK: - inits
    
    deinit {
        releaseSubscriptions()
    }
    
    // MARK: - Logic
    
    func getProductList(onSuccess: @escaping ([ProductModel]) -> Void,
                        onError: @escaping (Error) -> Void) {
        releaseSubscriptions()
        
        let url = ApiUtility.createGetProductListURL()
        
        getProductListSub = defaultSession
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductListResponse.self, decoder: jsonDecoder)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        onError(error)
                    }
                },
                receiveValue: { response in
                    onSuccess(response.list)
                }
            )
    }
    
    // MARK: - Helpers
    
    private func releaseSubscriptions() {
        getProductListSub?.cancel()
        getProductListSub = nil
    }
    
}

extension EdvoraRepository {
    
    private struct ApiUtility {
        private static let baseUrl = "https://assessment-edvora.herokuapp.com"
        
        static func createGetProductListURL() -> URL {
            URL(string: baseUrl)!
        }
    }
    
}
