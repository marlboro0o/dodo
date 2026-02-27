//
//  Product.swift
//  UIKit1_HomeWork
//
//  Created by Андрей on 23.01.2026.
//

import Foundation

struct Product: Codable, Equatable {
    var name: String
    var detail: String
    var price: Int
    var image: String
    var category: Category
    var suplements: [Suplement]?
    var countInBasket: Int?
    
    static func == (lhs: Product, rhs: Product) -> Bool {
            return
                lhs.name == rhs.name
        }
    
    func getSum() -> Int {
        var sum = price
        sum += suplements?.reduce(into: 0) { res, suplement in
            res += suplement.price
        } ?? 0
        
        return sum * (countInBasket ?? 1)
    }
    
    func productForBasket(suplements: [Suplement]) -> Product {
        Product(name: name,
                detail: detail,
                price: price,
                image: image,
                category: category,
                suplements: suplements,
                countInBasket: 1)
    }
    
    func updateCount(_ value: Int) -> Product {
        Product(name: name,
                detail: detail,
                price: price,
                image: image,
                category: category,
                suplements: suplements,
                countInBasket: value)
    }
}
