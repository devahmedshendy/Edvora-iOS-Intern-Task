//
//  ProductModel.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

struct ProductListResponse: Decodable {
    let list: [ProductModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        list = try container.decode([ProductModel].self)
    }
}

struct ProductModel: Decodable {
    let productName: String
    let brandName: String
    let price: Int
    let address: ProductAddressModel
    let description: String
    let date: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brandName = "brand_name"
        case price = "price"
        case address = "address"
        case description = "discription"
        case date = "date"
        case imageUrl = "image"
    }
}

struct ProductAddressModel: Decodable {
    let state: String
    let city: String
}
