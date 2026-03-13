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
    var size: Product.Size?
    var dough: Product.Dough?
    
    static func == (lhs: Product, rhs: Product) -> Bool {
            return
                lhs.name == rhs.name
        }
    
    func getSum() -> Int {
        var sum = price
        sum += suplements?.reduce(into: 0) { res, suplement in
            res += suplement.price
        } ?? 0
        
        let result = sum * (countInBasket ?? 1)
        return result
    }
    
    func productForBasket(suplements: [Suplement], size: Size, dough: Dough) -> Product {
        Product(name: name,
                detail: detail,
                price: price,
                image: image,
                category: category,
                suplements: suplements,
                countInBasket: countInBasket == nil ? 1 : countInBasket,
                size: size,
                dough: dough)
    }
    
    func updateCount(_ value: Int) -> Product {
        Product(name: name,
                detail: detail,
                price: price,
                image: image,
                category: category,
                suplements: suplements,
                countInBasket: value,
                size: size,
                dough: dough)
    }
}

extension Product {
    enum Size: Int, Codable {
        case size20
        case size25
        case size30
        case size35
        
        func description() -> String {
            switch self {
            case .size20:
                return "20 cm"
            case .size25:
                return "25 cm"
            case .size30:
                return "30 cm"
            case .size35:
                return "35 cm"
            }
        }
    }
    
    enum Dough: Int, Codable {
        case tradition
        case thin
        
        func description() -> String {
            switch self {
            case .tradition:
                return "традиционное"
            case .thin:
                return "тонкое"
            }
        }
    }
    
    static func defaultSize() -> Product.Size {
        Product.Size.size30
    }
    
    static func defaultDough() -> Product.Dough {
        Product.Dough.thin
    }
}
