//
//  ApiRespository.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

protocol ApiRespository {
    func getProductList(onSuccess: @escaping ([ProductModel]) -> Void,
                        onError: @escaping (Error) -> Void)
}


