//
//  ProductDto.swift
//  Edvora-iOS-Intern-Task
//
//  Created by Ahmed Shendy on 2/5/22.
//

import Foundation

struct ProductDto {
    let id: UUID
    let name: String
    let brand: String
    let price: String
    let state: String
    let city: String
    let _description: String
    let imageUrl: String

    var location: String { "\(city), \(state)" }
    
    private let dateString: String
    var formattedDate: String {
        dateFormatter.string(from: dateString.fromISOtoDate())
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        return formatter
    }
    
}

// MARK: - inits

extension ProductDto {
    init(from model: ProductModel) {
        id = UUID()
        name = model.productName
        brand = model.brandName
        price = "$ \(model.price)"
        dateString = model.date
        state = model.address.state
        city = model.address.city
        _description = model.description
        imageUrl = model.imageUrl
    }
}

// MARK: - Hashable

extension ProductDto: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: ProductDto, rhs: ProductDto) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - CustomStringConvertible

extension ProductDto: CustomStringConvertible {
    var description: String {
        """
\n{
  id: \(id),
  name: \(name),
  brand: \(brand),
  price: \(price),
  state: \(state),
  city: \(city),
  date: \(formattedDate),
  description: \(_description),
  imageUrl: \(imageUrl)
}
"""
    }
}
