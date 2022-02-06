//
//  HttpDataSource.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/6/22.
//

import Foundation

protocol HttpDataSource {
    func getImage(_ imageUrl: String,
                  onSuccess: @escaping (Data) -> Void,
                  onError: @escaping (Error) -> Void)
}
